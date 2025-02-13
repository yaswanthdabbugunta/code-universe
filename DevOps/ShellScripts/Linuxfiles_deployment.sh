#!/bin/bash

# Read inputs
read -p "Enter the source folder: " sourcefolder
read -p "Enter the destination folder: " destinationfolder
read -p "Enter the environment (QA, UAT, Production): " env
read -p "Enter the version (internal or external): " version
read -p "Enter the version number (v1 or v2): " version_number
logfile_path="/usr/share/nginx/logs"

# Get the current date and time for the log files
datetime=$(date +"%Y-%m-%d_%H-%M-%S")
# Extract the base directory name from the destination folder path
dirname=$(basename "$destinationfolder")
# Set log file names based on the version
if [ "$version" = "internal" ]; then
    logfile="${logfile_path}/${env}_${dirname}_internaldeployment_${datetime}.txt"
elif [ "$version" = "external" ]; then
    logfile="${logfile_path}/${env}_${dirname}_externaldeployment_${datetime}.txt"
else
    echo "Invalid version specified. Use 'internal' or 'external'."
    exit 1
fi

# Extract the base directory name from the destination folder path
#dirname=$(basename "$destinationfolder")

#Backup
if [ "$version_number" = "v2" ]; then
    backupdestination="/usr/share/nginx/html-r3-backup/${dirname}_backup_$datetime"
    # Copy the directory and handle errors
    if cp -rf "$destinationfolder" "$backupdestination" 2>> "$logfile"; then
        echo "Directory copied to: $backupdestination" | tee -a "$logfile"
    else
        echo "Error: Failed to copy directory to $backupdestination" | tee -a "$logfile"
        exit 1
    fi

elif [ "$version_number" = "v1" ]; then
    backupdestination="/usr/share/nginx/html-backup/${dirname}_backup_$datetime"
    # Copy the directory and handle errors
    if cp -rf "$destinationfolder" "$backupdestination" 2>> "$logfile"; then
        echo "Directory copied to: $backupdestination" | tee -a "$logfile"
    else
        echo "Error: Failed to copy directory to $backupdestination" | tee -a "$logfile"
        exit 1
    fi

else
    echo "Invalid version_number" | tee -a "$logfile"
    exit 1
fi


# Function to log messages
log_message() {
    echo "$1" | tee -a "$logfile"
}

# Start logging
log_message "Starting deployment script for $env $version_number $version."

# Check if source folder exists
if [ ! -d "$sourcefolder" ]; then
    log_message "Source folder does not exist."
    exit 1
fi

# Check if destination folder exists
if [ ! -d "$destinationfolder" ]; then    
    log_message "Destination folder does not exist."
    exit 1
fi


# Define the files and directories to remove
landing_files="index.html"

# Define the main.js file path
mainjsfile="$destinationfolder/main.js"

# Check if the main.js file exists
if [ ! -f "$mainjsfile" ]; then
    echo "Error: $mainjsfile does not exist." | tee -a "$logfile"
    exit 1
fi

# Perform specific operations based on the destination folder
case "$destinationfolder" in
    "/usr/share/nginx/html/landing" | "/usr/share/nginx/html/landing-internal")
        ls -la $destinationfolder 2>> "$logfile"
        log_message "Removing specific files from /usr/share/nginx/html/"
        sudo rm -rf "/usr/share/nginx/html/$landing_files" 2>> "$logfile"
        log_message "Copying files from $sourcefolder to $destinationfolder and /usr/share/nginx/html"
        cp -rf "$sourcefolder"/* "$destinationfolder" 2>> "$logfile"
        cp -rf "$sourcefolder"/* /usr/share/nginx/html 2>> "$logfile"
        chown -R op_7400:tsg3 /usr/share/nginx/html/*
        # Log the first 5 lines of index.html
        head "$destinationfolder"/index.html -n 10 | tee -a "$logfile"
        
# Perform URL searches based on environment, version number, and version type
if [ "$env" = "QA" ]; then
    if [ "$version_number" = "v2" ] && [ "$version" = "internal" ]; then
        if ! grep "xyz.com " "$mainjsfile" >> "$logfile" 2>&1; then
            echo "Error: URL not found for QA v2 internal in $mainjsfile" | tee -a "$logfile"
        fi
    elif [ "$version_number" = "v2" ] && [ "$version" = "external" ]; then
        if ! grep "xyz.com " "$mainjsfile" >> "$logfile" 2>&1; then
            echo "Error: URL not found for QA v2 external in $mainjsfile" | tee -a "$logfile"
        fi
    elif [ "$version_number" = "v1" ] && [ "$version" = "external" ]; then
        if ! grep "xyz.com " "$mainjsfile" >> "$logfile" 2>&1; then
            echo "Error: URL not found for QA v1 external in $mainjsfile" | tee -a "$logfile"
        fi
    elif [ "$version_number" = "v1" ] && [ "$version" = "internal" ]; then
        if ! grep "xyz.com" "$mainjsfile" >> "$logfile" 2>&1; then
            echo "Error: URL not found for QA v1 internal in $mainjsfile" | tee -a "$logfile"
        fi
    fi
elif [ "$env" = "UAT" ]; then
    if [ "$version_number" = "v2" ] && [ "$version" = "internal" ]; then
        if ! grep "xyz.com" "$mainjsfile" >> "$logfile" 2>&1; then
            echo "Error: URL not found for UAT v2 internal in $mainjsfile" | tee -a "$logfile"
        fi
    elif [ "$version_number" = "v2" ] && [ "$version" = "external" ]; then
        if ! grep "xyz.com" "$mainjsfile" >> "$logfile" 2>&1; then
            echo "Error: URL not found for UAT v2 external in $mainjsfile" | tee -a "$logfile"
        fi
    elif [ "$version_number" = "v1" ] && [ "$version" = "external" ]; then
        if ! grep "xyz.com" "$mainjsfile" >> "$logfile" 2>&1; then
            echo "Error: URL not found for UAT v1 external in $mainjsfile" | tee -a "$logfile"
        fi
    elif [ "$version_number" = "v1" ] && [ "$version" = "internal" ]; then
        if ! grep "xyz.com " "$mainjsfile" >> "$logfile" 2>&1; then
            echo "Error: URL not found for UAT v1 internal in $mainjsfile" | tee -a "$logfile"
        fi
    fi
else
    echo "Error: Invalid environment specified." | tee -a "$logfile"
    exit 1
fi
        
        log_message "Setting permissions for /usr/share/nginx/html/*"
        chmod -R 755 /usr/share/nginx/html/* 2>> "$logfile"
        ;;
    "/usr/share/nginx/html-r3/landing-r3" | "/usr/share/nginx/html-r3/landing-internal-r3")
        ls -la $destinationfolder 2>> "$logfile"
        log_message "Removing specific files from /usr/share/nginx/html-r3/"
        sudo rm -rf "/usr/share/nginx/html-r3/$landing_files" 2>> "$logfile"
        log_message "Copying files from $sourcefolder to $destinationfolder and /usr/share/nginx/html-r3"
        cp -rf "$sourcefolder"/* "$destinationfolder" 2>> "$logfile"
        cp -rf "$sourcefolder"/* /usr/share/nginx/html-r3 2>> "$logfile"
        chown -R op_7400:tsg3 /usr/share/nginx/html-r3/*
        # Log the first 5 lines of index.html
        head "$destinationfolder"/index.html -n 10 | tee -a "$logfile"
        
# Perform URL searches based on environment, version number, and version type
if [ "$env" = "QA" ]; then
    if [ "$version_number" = "v2" ] && [ "$version" = "internal" ]; then
        if ! grep "xyz.com " "$mainjsfile" >> "$logfile" 2>&1; then
            echo "Error: URL not found for QA v2 internal in $mainjsfile" | tee -a "$logfile"
        fi
    elif [ "$version_number" = "v2" ] && [ "$version" = "external" ]; then
        if ! grep "xyz.com " "$mainjsfile" >> "$logfile" 2>&1; then
            echo "Error: URL not found for QA v2 external in $mainjsfile" | tee -a "$logfile"
        fi
    elif [ "$version_number" = "v1" ] && [ "$version" = "external" ]; then
        if ! grep "xyz.com " "$mainjsfile" >> "$logfile" 2>&1; then
            echo "Error: URL not found for QA v1 external in $mainjsfile" | tee -a "$logfile"
        fi
    elif [ "$version_number" = "v1" ] && [ "$version" = "internal" ]; then
        if ! grep "xyz.com" "$mainjsfile" >> "$logfile" 2>&1; then
            echo "Error: URL not found for QA v1 internal in $mainjsfile" | tee -a "$logfile"
        fi
    fi   
elif [ "$env" = "UAT" ]; then
    if [ "$version_number" = "v2" ] && [ "$version" = "internal" ]; then
        if ! grep "xyz.com" "$mainjsfile" >> "$logfile" 2>&1; then
            echo "Error: URL not found for UAT v2 internal in $mainjsfile" | tee -a "$logfile"
        fi
    elif [ "$version_number" = "v2" ] && [ "$version" = "external" ]; then
        if ! grep "xyz.com" "$mainjsfile" >> "$logfile" 2>&1; then
            echo "Error: URL not found for UAT v2 external in $mainjsfile" | tee -a "$logfile"
        fi
    elif [ "$version_number" = "v1" ] && [ "$version" = "external" ]; then
        if ! grep "xyz.com" "$mainjsfile" >> "$logfile" 2>&1; then
            echo "Error: URL not found for UAT v1 external in $mainjsfile" | tee -a "$logfile"
        fi
    elif [ "$version_number" = "v1" ] && [ "$version" = "internal" ]; then
        if ! grep "xyz.com " "$mainjsfile" >> "$logfile" 2>&1; then
            echo "Error: URL not found for UAT v1 internal in $mainjsfile" | tee -a "$logfile"
        fi
    fi
else
    echo "Error: Invalid environment specified." | tee -a "$logfile"
    exit 1
fi
        
        log_message "Setting permissions for /usr/share/nginx/html-r3/*"
        chmod -R 755 /usr/share/nginx/html-r3/* 2>> "$logfile"
        ;;
    *)
        log_message "Removing all files in $destinationfolder"
        rm -rf "$destinationfolder"/* 2>> "$logfile"
        log_message "Copying files from $sourcefolder to $destinationfolder"
        cp -rf "$sourcefolder"/* "$destinationfolder" 2>> "$logfile"
        chown -R op_7400:tsg3 "$destinationfolder"/*
        chmod -R 755 "$destinationfolder"/* 2>> "$logfile"
        ls -la $destinationfolder 2>> "$logfile"
        # Log the first 5 lines of index.html
        head "$destinationfolder"/index.html -n 10 | tee -a "$logfile"
        
# Perform URL searches based on environment, version number, and version type
if [ "$env" = "QA" ]; then
    if [ "$version_number" = "v2" ] && [ "$version" = "internal" ]; then
        if ! grep "xyz.com " "$mainjsfile" >> "$logfile" 2>&1; then
            echo "Error: URL not found for QA v2 internal in $mainjsfile" | tee -a "$logfile"
        fi
    elif [ "$version_number" = "v2" ] && [ "$version" = "external" ]; then
        if ! grep "xyz.com " "$mainjsfile" >> "$logfile" 2>&1; then
            echo "Error: URL not found for QA v2 external in $mainjsfile" | tee -a "$logfile"
        fi
    elif [ "$version_number" = "v1" ] && [ "$version" = "external" ]; then
        if ! grep "xyz.com " "$mainjsfile" >> "$logfile" 2>&1; then
            echo "Error: URL not found for QA v1 external in $mainjsfile" | tee -a "$logfile"
        fi
    elif [ "$version_number" = "v1" ] && [ "$version" = "internal" ]; then
        if ! grep "xyz.com" "$mainjsfile" >> "$logfile" 2>&1; then
            echo "Error: URL not found for QA v1 internal in $mainjsfile" | tee -a "$logfile"
        fi
    fi
elif [ "$env" = "UAT" ]; then
    if [ "$version_number" = "v2" ] && [ "$version" = "internal" ]; then
        if ! grep "xyz.com" "$mainjsfile" >> "$logfile" 2>&1; then
            echo "Error: URL not found for UAT v2 internal in $mainjsfile" | tee -a "$logfile"
        fi
    elif [ "$version_number" = "v2" ] && [ "$version" = "external" ]; then
        if ! grep "xyz.com" "$mainjsfile" >> "$logfile" 2>&1; then
            echo "Error: URL not found for UAT v2 external in $mainjsfile" | tee -a "$logfile"
        fi
    elif [ "$version_number" = "v1" ] && [ "$version" = "external" ]; then
        if ! grep "xyz.com" "$mainjsfile" >> "$logfile" 2>&1; then
            echo "Error: URL not found for UAT v1 external in $mainjsfile" | tee -a "$logfile"
        fi
    elif [ "$version_number" = "v1" ] && [ "$version" = "internal" ]; then
        if ! grep "xyz.com " "$mainjsfile" >> "$logfile" 2>&1; then
            echo "Error: URL not found for UAT v1 internal in $mainjsfile" | tee -a "$logfile"
        fi
    fi
else
    echo "Error: Invalid environment specified." | tee -a "$logfile"
    exit 1
fi
        

        ;;
esac

log_message "Deployment script completed successfully."

# Restart nginx service
log_message "Restarting nginx service"
if sudo systemctl restart nginx; then
    log_message "Nginx service restarted successfully."
else
    log_message "Failed to restart Nginx service."
    exit 1
fi

# Post-message indicating the end of the deployment process
log_message "Deployment process for $env $version_number $version completed successfully."
