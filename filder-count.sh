#!/bin/bash

# Prompt the user to enter a path
echo "Enter the path to analyze:"
read path

# Check if the entered path exists
if [ ! -d "$path" ]; then
    echo "Error: The path '$path' does not exist."
    exit 1
fi

# List out the folders in the entered path and count the number of files in each folder
for folder in "$path"/*; do
    if [ -d "$folder" ]; then
        folder_name=$(basename "$folder")
        file_count=$(find "$folder" -maxdepth 1 -type f | wc -l)
        echo "Folder: \033[1;32m$folder_name\033[0m - Files: \033[1;32m$file_count\033[0m"
    fi
done
