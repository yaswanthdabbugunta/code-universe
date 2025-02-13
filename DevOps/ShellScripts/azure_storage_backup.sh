#!/bin/bash

# Get the current date in the format YYYYMMDD and extract the parts we need
datetime=$(date +%Y%m%d)
year=${datetime:2:2}
month=${datetime:4:2}
day=${datetime:6:2}

# Construct the current date in the format ddmmyy
current_date="${day}${month}${year}"

# Prompt the user for input
read -p "Enter storage account name: " staccname
read -p "Enter account key: " acckey
read -p "Enter file path: " filepath

# Create directories with today's date if they don't exist
templatesfullpath="${filepath}/${current_date}/templates"
uploadsfullpath="${filepath}/${current_date}/uploads"
formsfullpath="${filepath}/${current_date}/forms"

mkdir -p "${templatesfullpath}"
mkdir -p "${uploadsfullpath}"
mkdir -p "${formsfullpath}"

# Download blobs to the specified directory with today's date
az storage blob download-batch --source templates --destination "${templatesfullpath}" --pattern "*.pdf" --account-name "${staccname}" --account-key "${acckey}"
az storage blob download-batch --source templates --destination "${templatesfullpath}" --pattern "*.png" --account-name "${staccname}" --account-key "${acckey}"
az storage blob download-batch --source templates --destination "${templatesfullpath}" --pattern "*.jpeg" --account-name "${staccname}" --account-key "${acckey}"
az storage blob download-batch --source templates --destination "${templatesfullpath}" --pattern "*.xlsx" --account-name "${staccname}" --account-key "${acckey}"
az storage blob download-batch --source templates --destination "${templatesfullpath}" --pattern "*.txt" --account-name "${staccname}" --account-key "${acckey}"
az storage blob download-batch --source uploads --destination "${uploadsfullpath}" --pattern "*.pdf" --account-name "${staccname}" --account-key "${acckey}"
az storage blob download-batch --source uploads --destination "${uploadsfullpath}" --pattern "*.png" --account-name "${staccname}" --account-key "${acckey}"
az storage blob download-batch --source uploads --destination "${uploadsfullpath}" --pattern "*.jpeg" --account-name "${staccname}" --account-key "${acckey}"
az storage blob download-batch --source uploads --destination "${uploadsfullpath}" --pattern "*.xlsx" --account-name "${staccname}" --account-key "${acckey}"
az storage blob download-batch --source uploads --destination "${uploadsfullpath}" --pattern "*.txt" --account-name "${staccname}" --account-key "${acckey}"
az storage blob download-batch --source generatedforms --destination "${formsfullpath}" --pattern "*.pdf" --account-name "${staccname}" --account-key "${acckey}"
az storage blob download-batch --source generatedforms --destination "${formsfullpath}" --pattern "*.png" --account-name "${staccname}" --account-key "${acckey}"
az storage blob download-batch --source generatedforms --destination "${formsfullpath}" --pattern "*.jpeg" --account-name "${staccname}" --account-key "${acckey}"
az storage blob download-batch --source generatedforms --destination "${formsfullpath}" --pattern "*.xlsx" --account-name "${staccname}" --account-key "${acckey}"
az storage blob download-batch --source generatedforms --destination "${formsfullpath}" --pattern "*.txt" --account-name "${staccname}" --account-key "${acckey}"

echo
echo "Download completed."
