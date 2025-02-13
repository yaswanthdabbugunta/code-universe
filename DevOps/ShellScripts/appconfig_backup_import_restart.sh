#!/bin/bash

# Enable exit on error
set -e

# Set the log folder and file with timestamp
log_folder="$HOME"
timestamp=$(date +"%m-%d-%Y_%H-%M-%S")
log_file="log_${timestamp}.txt"
log_path="${log_folder}/${log_file}"

echo "Logging command output to ${log_path}"
echo

# Function to log messages to both console and log file
log_message() {
  echo "$1" | tee -a "$log_path"
}

# Prompt for App Configuration connection string
read -p "Enter the Appconfig Connection String: " connection_string_name

# Step 1: Backup current App Configuration values
log_message "Taking backup of current App Configuration values..."
if ! az appconfig kv export --destination file --path appconfig_backup.json --format json --connection-string "$connection_string_name"; then
  log_message "Failed to export current App Configuration values. Aborting."
  exit 1
fi
log_message "Backup completed and saved to appconfig_backup.json."

# Step 2: Import new App Configuration values from the JSON file
log_message "Importing new App Configuration values from UAT-Update-AppConfig-v2.json..."
if ! az appconfig kv import --source file --path UAT-Update-AppConfig-v2.json --format json --connection-string "$connection_string_name"; then
  log_message "Failed to import new App Configuration values. Aborting."
  exit 1
fi
log_message "Import completed."

# Step 3: Export the updated App Configuration values
log_message "Exporting updated App Configuration values..."
if ! az appconfig kv export --destination file --path appconfig_after_import.json --format json --connection-string "$connection_string_name"; then
  log_message "Failed to export App Configuration values after import. Aborting."
  exit 1
fi
log_message "Export completed and saved to appconfig_after_import.json."

# Restarting all pods in the dci-ext-v2-dev namespace
log_message "Restarting all pods in dci-ext-v2-dev namespace..."
if ! kubectl rollout restart deployment -n dci-ext-v2-dev; then
  log_message "Failed to restart pods in dci-ext-v2-dev namespace."
  exit 1
fi
log_message "Pods restarted in dci-ext-v2-dev namespace."

# Restarting all pods in the dci-int-v2-dev namespace
log_message "Restarting all pods in dci-int-v2-dev namespace..."
if ! kubectl rollout restart deployment -n dci-int-v2-dev; then
  log_message "Failed to restart pods in dci-int-v2-dev namespace."
  exit 1
fi
log_message "Pods restarted in dci-int-v2-dev namespace."

# Restarting all pods in the dci-bkgd-v2-dev namespace
log_message "Restarting all pods in dci-bkgd-v2-dev namespace..."
if ! kubectl rollout restart deployment -n dci-bkgd-v2-dev; then
  log_message "Failed to restart pods in dci-bkgd-v2-dev namespace."
  exit 1
fi
log_message "Pods restarted in dci-bkgd-v2-dev namespace."

log_message ""
log_message "Command execution completed. Log saved to ${log_path}"
