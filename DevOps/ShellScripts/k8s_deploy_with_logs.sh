
#!/bin/bash

# Enable exit on error
set -e

# Array of namespaces
namespaces=("ns1" "ns2" "ns3")

# Set log path to user home directory
logpath="$HOME"

# Set directory containing YAML files
yamldir="/Deployment_R3/Deployment_yamls"

# Get the current date and time in YYYYMMDD_HHMMSS format
timestamp=$(date +"%Y%m%d_%H%M%S")

# Define the output log file
logfile="${logpath}/deployments_${timestamp}.txt"

# Previous image tags
echo "Logging previous image tags" > "$logfile"

# Loop through each namespace
for namespace in "${namespaces[@]}"; do
    echo "Namespace: $namespace" >> "$logfile"

    # Retrieve and log the tags of the images before deployment
    echo "Tags of the images before deployment:" >> "$logfile"
    kubectl get deployments -n "$namespace" -o wide --ignore-not-found >> "$logfile"
done



# Initialize the logfile
echo "Logging deployment and pod details" > "$logfile"

# Loop through each namespace
for namespace in "${namespaces[@]}"; do
    echo "Namespace: $namespace" >> "$logfile"

    # Delete existing deployments using YAML files
    echo "Deleting deployments for namespace $namespace..."
    kubectl delete -f "${yamldir}/${namespace}/" --ignore-not-found

    # Apply new deployment YAML files
    echo "Applying new deployment YAML files for namespace $namespace..."
    kubectl apply -f "${yamldir}/${namespace}/"

    # Log deployment details
    kubectl get deployments -n "$namespace" -o wide >> "$logfile"

    # Log pod status
    echo "Pod status for namespace $namespace" >> "$logfile"
    kubectl get pods -n "$namespace" -o wide >> "$logfile"
    echo "--------------------------------------" >> "$logfile"
done

echo "Deployment and pod details logged successfully in $logfile."
