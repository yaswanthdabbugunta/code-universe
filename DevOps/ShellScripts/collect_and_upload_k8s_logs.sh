#!/bin/bash

# Enable error handling
set -e

# Get the current date and time in YYYY-MM-DD_HH-MM-SS format
CURRENT_DATETIME=$(date +"%Y-%m-%d_%H-%M-%S")

# Set the namespaces and log directory
NAMESPACES=("ns1" "ns2" "ns3")
LOG_DIR="/opt"

# Check if the log directory exists
if [ ! -d "$LOG_DIR" ]; then
    echo "The directory $LOG_DIR does not exist. Please create it and try again."
    exit 1
fi

# Delete all files in the log directory
echo "Deleting all existing log files in $LOG_DIR"
rm -f "$LOG_DIR"/*.txt

# Loop through each namespace
for NAMESPACE in "${NAMESPACES[@]}"; do
    echo "Processing namespace: $NAMESPACE"

    # Get the list of pods in the namespace
    PODS=$(kubectl get pods -n "$NAMESPACE" -o name)
    
    # Loop through each pod and save logs
    for POD in $PODS; do
        POD_NAME=$(basename "$POD")
        LOG_FILE="${LOG_DIR}/${POD_NAME}_${CURRENT_DATETIME}.txt"
        echo "Saving logs for pod $POD to $LOG_FILE"
        kubectl logs -n "$NAMESPACE" "$POD" > "$LOG_FILE"
    done
done

echo "Logs have been saved to $LOG_DIR"

# Upload logs to Azure Storage using az CLI
STORAGE_ACCOUNT_NAME="xxx" 
CONTAINER_NAME="xxx"
ACCOUNT_KEY="xxxx"

echo "Uploading logs to Azure Storage"
az storage blob upload-batch --account-name "$STORAGE_ACCOUNT_NAME" --account-key "$ACCOUNT_KEY" --destination "$CONTAINER_NAME" --source "$LOG_DIR" --pattern "*.txt"

echo "Log upload completed."
