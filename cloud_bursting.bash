#!/bin/bash

# Settings
THRESHOLD_UP=75
THRESHOLD_DOWN=50
INSTANCE="scaled-vm"
#ZONE="us-west3-a"

# Get CPU usage
#CPU=$(mpstat 1 1 | awk '/all/ {print 100 - $NF}')
CPU=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1}')
echo "CPU: $CPU%"

# Check if VM exists
VM_RUNNING=$(gcloud compute instances list --format="value(name)" | grep -w "$INSTANCE")

if [[ -z "$VM_RUNNING" ]]; then
    echo "No VM found with name $INSTANCE."
else
    echo "VM $INSTANCE is running."
fi

echo "$CPU > $THRESHOLD_UP" | bc -l

if [ "$(echo "$CPU > $THRESHOLD_UP" | bc -l)" = "1" ]; then
    if [[ -z "$VM_RUNNING" ]]; then
        echo "High CPU ($CPU%). Starting VM..."
        gcloud compute instances create "$INSTANCE" --zone=us-west3-a --machine-type=n1-standard-1 --image-family=ubuntu-2204-lts --image-project=ubuntu-os-cloud
    else
        echo "VM already running."
    fi
elif [ "$(echo "$CPU < $THRESHOLD_DOWN" | bc -l)" = "1" ]; then
    if [[ -n "$VM_RUNNING" ]]; then
        echo "Low CPU ($CPU%). Stopping VM..."
        gcloud compute instances delete "$INSTANCE" --zone=us-west3-a --quiet
    else
        echo "No running VM to stop."
    fi
else
    echo "CPU within range. No action."
fi

