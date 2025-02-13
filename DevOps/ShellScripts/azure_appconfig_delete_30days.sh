#!/bin/bash

# Prompt the user to enter the appconfig directory path
read -p "Enter the appconfig directory path to clean up: " appconfig_dir

# Find and delete files older than 30 days in the appconfig directory
find "$appconfig_dir" -type f ! -mtime -30 -exec rm -f {} \;

echo "Cleanup completed for directory: $appconfig_dir"
