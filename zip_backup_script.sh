#!/bin/bash

# Check if the script is being run as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 
   exit 1
fi

# Prompt user for folder path
read -p "Enter the folder path: " folder_path

# Check if the entered folder exists
if [ ! -d "$folder_path" ]; then
    echo "Folder does not exist!"
    exit 1
fi

# Prompt user for backup folder path
read -p "Enter the backup folder path: " backup_path

# Check if the backup folder exists, if not create it
if [ ! -d "$backup_path" ]; then
    echo "Backup folder does not exist, creating..."
    mkdir -p "$backup_path"
fi

# Get the base name of the folder
folder_name=$(basename "$folder_path")

# Create a timestamp for the zip file
timestamp=$(date +"%Y-%m-%d_%H-%M-%S")

# Zip the folder files
zip_file="$backup_path/${folder_name}_${timestamp}.zip"
zip -r "$zip_file" "$folder_path"

# Check if zip was successful
if [ $? -eq 0 ]; then
    echo "Folder files zipped successfully."
    echo "Zip file location: $zip_file"
else
    echo "Error zipping folder files."
    exit 1
fi

# Optionally, you can remove the original files after zipping
# rm -rf "$folder_path/*"

exit 0

