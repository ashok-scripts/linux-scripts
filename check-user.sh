#!/bin/bash

# Path to the file containing the list of servers
servers_file="servers.txt"
user_to_check="nani"  # Replace with the actual username you want to check
home_dir="/home/$user_to_check"  # Home directory for the user
shell="/usr/bin/bash"  # Default shell for the user
source_keys_file="/opt/linux-scripts/as.txt"  # Source file containing the SSH keys

# Loop through each server
for server in "${servers[@]}"; do
  # Check if the user exists on the server
  if ssh "$server" id "$user_to_check" &>/dev/null; then
    echo "User '$user_to_check' exists on $server"
  else
    # Create the user on the server
    ssh "$server" sudo useradd -m -d "$home_dir" -s "$shell" "$user_to_check"
    if [[ $? -eq 0 ]]; then
      echo "User '$user_to_check' created successfully on $server."
    else
      echo "Failed to create user '$user_to_check' on $server."
      continue
    fi
  fi

  # Check if the .ssh directory exists for the user, and create it if it doesn't
  ssh "$server" "sudo -u $user_to_check bash -c '[[ -d $home_dir/.ssh ]] || (mkdir -p $home_dir/.ssh && chmod 700 $home_dir/.ssh)'"

  # Generate SSH keys if they don't exist
  ssh "$server" "sudo -u $user_to_check bash -c '[[ -f $home_dir/.ssh/id_rsa ]] || ssh-keygen -t rsa -f $home_dir/.ssh/id_rsa -N \"\"'"

  if [[ $? -eq 0 ]]; then
    echo "SSH key generated successfully for user '$user_to_check' on $server."
  else
    echo "Failed to generate SSH key for user '$user_to_check' on $server."
  fi

  # Check if the authorized_keys file exists, and create it if it doesn't
  ssh "$server" "sudo -u $user_to_check bash -c '[[ -f $home_dir/.ssh/authorized_keys ]] || touch $home_dir/.ssh/authorized_keys && chmod 600 $home_dir/.ssh/authorized_keys'"

  # Copy the content from the source keys file to the authorized_keys file
  scp "$source_keys_file" "$server:/tmp/source_keys.txt"
  ssh "$server" "sudo bash -c 'cat /tmp/source_keys.txt >> $home_dir/.ssh/authorized_keys && rm /tmp/source_keys.txt'"

  if [[ $? -eq 0 ]]; then
    echo "SSH keys added to authorized_keys for user '$user_to_check' on $server."
  else
    echo "Failed to add SSH keys to authorized_keys for user '$user_to_check' on $server."
  fi
done
