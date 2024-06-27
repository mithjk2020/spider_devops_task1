#!/bin/bash

log_file="manage_users.log"
user_activity_log="user_activity.log"

while IFS=, read -r username group permission
do
    action() {
        echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$user_activity_log"
    }

    if id "$username" &>/dev/null; then
        action "User '$username' activity recorded."
    else
        sudo useradd -m "$username" >> "$log_file" 2>&1
        if [ $? -eq 0 ]; then
            action "User '$username' created successfully."
        else
            action "Failed to create user '$username'."
            continue
        fi
    fi
    
    sudo usermod -g "$group" "$username" >> "$log_file" 2>&1
    if [ $? -eq 0 ]; then
        action "Group modified for user '$username'."
    else
        action "Failed to modify group for user '$username'."
    fi
    
    sudo chmod "$permission" /home/"$username" >> "$log_file" 2>&1
    if [ $? -eq 0 ]; then
        action "Permissions changed for /home/'$username'."
    else
        action "Failed to change permissions for /home/'$username'."
    fi
    
    sudo mkdir -p /home/"$username"/projects >> "$log_file" 2>&1
    if [ $? -eq 0 ]; then
        action "Created directory /home/'$username'/projects."
    else
        action "Failed to create directory /home/'$username'/projects."
    fi
    
    sudo touch /home/"$username"/projects/README.md >> "$log_file" 2>&1
    if [ $? -eq 0 ]; then
        action "Created file /home/'$username'/projects/README.md."
    else
        action "Failed to create file /home/'$username'/projects/README.md."
    fi
    
    action "Welcome, '$username'! You can start working on your projects now."
    
done < usernames.csv
