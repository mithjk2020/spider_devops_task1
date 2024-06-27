#!/bin/bash

user_activity_log="user_activity.log"

#to delete users if inactive for more than 30 days
limit=30

log_file="manage_users.log"

current_date=$(date '+%Y-%m-%d')

while IFS= read -r line
do
    last_activity_date=$(echo "$line" | cut -d' ' -f1)
    username=$(echo "$line" | cut -d' ' -f4)

    #to find inactive days 
    if [ -n "$last_activity_date" ]; then
        days_inactive=$(( ( $(date -d "$current_date" +%s) - $(date -d "$last_activity_date" +%s) ) / 86400 ))

        if [ $days_inactive -ge $limit ]; then
            sudo userdel -r "$username" 
            echo "$(date '+%Y-%m-%d %H:%M:%S') - User '$username' has been inactive for $days_inactive days so deleting '$username'." >> "$log_file"
        fi
    fi
done < "$user_activity_log"
