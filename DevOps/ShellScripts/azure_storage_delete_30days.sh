#!/bin/bash

# Prompt the user to enter the directory path
read -p "Enter the directory path to clean up: " storage_dir

# Find and delete files older than 30 days in the storage directory
find "$storage_dir" -type f ! -mtime -30 -exec rm -f {} \;

echo "Cleanup completed for directory: $storage_dir"
