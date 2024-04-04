#!/bin/bash

# Get user input
read -p "Enter username: " username
read -p "Enter shell (e.g., /bin/bash): " shell
read -p "Enter user ID (UID): " uid
read -p "Enter group name (leave blank for no group): " groupname

# Check if user already exists
if id "$username" >/dev/null 2>&1; then
  echo "User '$username' already exists."
  exit 1
fi

# Create user with specified UID and shell
sudo useradd -m -s "$shell" -u "$uid" "$username"

# Check if group needs to be created
if [[ ! -z "$groupname" ]]; then
  # Check if group exists
  if ! grep -q "$groupname" /etc/group; then
    sudo groupadd "$groupname"
  fi
  # Add user to the group
  sudo usermod -a -G "$groupname" "$username"
fi

echo "User '$username' created successfully!"


