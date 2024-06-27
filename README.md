initially do sudo groupadd for all the groups mentioned in the csv file

then make sure the scripts are executable after creation by chmod +x filename

create the scripts in the same directory

the cronjob line(to run everyday at 9 am) would be:

#open crontab -e and enter this:
0 9 * * * /home/username/directory/user_check.sh
