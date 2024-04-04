#!/bin/bash

# Function to remove user from a group
remove_from_group() {
    read -p "Enter username: " username
    read -p "Enter group name: " groupname
    sudo userdel "$username" "$groupname"
    echo "User $username removed from group $groupname."
}

# Function to delete a user
delete_user() {
    read -p "Enter username to delete: " username
    sudo userdel --remove-home "$username"
    echo "User $username deleted."
}

# Main menu
while true; do
    echo "1. Remove user from group"
    echo "2. Delete user"
    echo "3. Exit"
    read -p "Choose an option: " choice

    case $choice in
        1) remove_from_group ;;
        2) delete_user ;;
        3) exit ;;
        *) echo "Invalid option. Please choose again." ;;
    esac
done

