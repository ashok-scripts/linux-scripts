#!/bin/bash

# Directory to be backed up
source_dir="/opt/ashok/scripts/"

# Destination directory for backup
backup_dir="/mnt/backup"

# Create a unique timestamp for the backup filename
timestamp=$(date +"%Y%m%d_%H%M%S")

# Name of the backup file
backup_file="backup_$timestamp.tar.gz"

# Create backup
tar -czf "$backup_dir/$backup_file" "$source_dir"

# Check if backup was successful
if [ $? -eq 0 ]; then
    echo "Backup successful: $backup_file"
else
    echo "Backup failed"
fi

