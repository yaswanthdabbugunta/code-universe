#!/bin/bash

# Enable exit on error
set -e

# Set the log folder and file with timestamp
log_folder="/opt"
timestamp=$(date +"%m-%d-%Y_%H-%M-%S")
log_file="log_${timestamp}.txt"
log_path="${log_folder}/${log_file}"

# Create log folder if it does not exist
mkdir -p "$log_folder"

# Prompt for storage account name and account key
read -p "Enter storage account name: " staccname
read -p "Enter account key: " acckey

# Start logging
echo "Logging started..." > "$log_path"
echo "Storage Account: $staccname" >> "$log_path"
echo "---------------------------------" >> "$log_path"
echo "Name                               Last Modified" >> "$log_path"
echo "---------------------------------" >> "$log_path"

# Log the status of files before upload
# Instead of XXX change to container name
az storage blob list --account-name "$staccname" --account-key "$acckey" --container-name xxx --output tsv --query "[].{Name:name, LastModified:properties.lastModified}" >> "$log_path"

# Upload files
az storage blob upload-batch -d xxx --account-name "$staccname" --account-key "$acckey" -s . --pattern "*.pdf" -t block --overwrite
az storage blob upload-batch -d xxx --account-name "$staccname" --account-key "$acckey" -s . --pattern "*.png" -t block --overwrite
az storage blob upload-batch -d xxx --account-name "$staccname" --account-key "$acckey" -s . --pattern "*.jpeg" -t block --overwrite
az storage blob upload-batch -d xxx --account-name "$staccname" --account-key "$acckey" -s . --pattern "*.xlsx" -t block --overwrite

# Log the status of files after upload
echo "---------------------------------" >> "$log_path"
echo "Status after upload:" >> "$log_path"
az storage blob list --account-name "$staccname" --account-key "$acckey" --container-name xxx --output tsv --query "[].{Name:name, LastModified:properties.lastModified}" >> "$log_path"

echo "---------------------------------" >> "$log_path"

# Restarting all pods in the xxx namespace
echo "Restarting all pods in xxx namespace..." >> "$log_path"
if ! kubectl rollout restart deployment -n xxx; then
    echo "Failed to restart pods in xxx namespace." >> "$log_path"
    exit 1
fi
echo "Pods restarted in xxx namespace." >> "$log_path"

# Restarting all pods in the xxx namespace
echo "Restarting all pods in xxx namespace..." >> "$log_path"
if ! kubectl rollout restart deployment -n xxx; then
    echo "Failed to restart pods in xxx namespace." >> "$log_path"
    exit 1
fi
echo "Pods restarted in xxx namespace." >> "$log_path"

# Restarting all pods in the xxx namespace
echo "Restarting all pods in xxx namespace..." >> "$log_path"
if ! kubectl rollout restart deployment -n xxx; then
    echo "Failed to restart pods in xxx namespace." >> "$log_path"
    exit 1
fi
echo "Pods restarted in xxx namespace." >> "$log_path"

echo "" >> "$log_path"
echo "Command execution completed. Log saved to $log_path"
