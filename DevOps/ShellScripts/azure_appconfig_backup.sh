#!/bin/bash
az account set --subscription xxxxxx
# Get the current date in the format YYYYMMDD and extract the parts we need
datetime=$(date +%Y%m%d)
year=${datetime:2:2}
month=${datetime:4:2}
day=${datetime:6:2}

# Construct the current date in the format ddmmyy
current_date="${day}${month}${year}"


# Prompt for the connection string
read -p "Enter the Appconfig Connection String: " connection_string_name

# Construct the backup file name with the current date
backup_file="ProductionAppconfigbackup_${current_date}.json"

# Construct the backup file path in the current directory
backup_path="./${backup_file}"

# Call the az appconfig command with the dynamic backup file path
az appconfig kv export --connection-string "${connection_string_name}" --destination file --path "${backup_path}" --format json --yes
