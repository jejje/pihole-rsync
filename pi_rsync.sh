#!/bin/bash 
# PiHole Sync
# Sync Two PiHoles from Master
#
# JejjE - https://jejje.net
# Credit for the idea: https://pastebin.com/KFzg7Uhi
# 
# This script makes use of two packages RSYNC, SSHPASS
#

#### Setup Vars ####
# What files to RSYNC
SYNCFILES=(gravity.db custom.list dhcp.leases local.list) 
# The Secondary PiHole Host
HOST=192.168.0.114
# Username on Secondary HOST
USER=pi
# Password on Secondary HOST, dont forget to change password
PSW=rasberry
# Update interval for CRONJOB
CRONTIME=15


# Print help
function print_help()
{
  echo -e "\e[32mSyntax: $0 [-i] [-s]"
  echo -e "\e[32m\t[-i]\e[39m install: Set up Cronjob, only run once"
  echo -e "\e[32m\t[-s]\e[39m sync: Syncing the files"
  exit 1
}

# Set up Cronjob
function process_install()
{
  	echo -e "Adding \e[32mCRONJOB\e[39m to crontab..."
  	# Make temporary cronfile
   	crontab -l > mycron
	# Echo into file
	echo -e "*/$CRONTIME * * * * /bin/bash /etc/pi_rsync.sh -s" >> mycron # Cron runs every 15 minutes
	# Install from the temporary cron file
	crontab mycron
	# Clean it up
	rm mycron
}

# Syncing the files
function process_sync()
{
   # Loop trough files
   for FILE in "${SYNCFILES[@]}"
   do
   		echo -e "Syncing \e[32m{$FILE}\e[39m over to \e[32m{$HOST}\e[39m..."
		RSYNC=$(sshpass -p "$PSW" rsync /etc/pihole/$FILE $USER@$HOST:/etc/pihole/)		
	done

	# Do updates
	echo -e "Running command \e[96mpihole -g\e[39m on \e[32m{$HOST}\e[39m"
	sshpass -p "$PSW" ssh $USER@$HOST "echo $PSW | sudo -S pihole -g"
	echo -e "Running command \e[96mservice pihole-FTL stop\e[39m on \e[32m{$HOST}\e[39m"
	sshpass -p "$PSW" ssh  $USER@$HOST "echo $PSW | sudo -S service pihole-FTL stop"
	echo -e "Running command \e[96mpkill pihole-FTL\e[39m on \e[32m{$HOST}\e[39m"
	sshpass -p "$PSW" ssh  $USER@$HOST "echo $PSW | sudo -S pkill pihole-FTL"
	echo -e "Running command \e[96mservice pihole-FTL start\e[39m on \e[32m{$HOST}\e[39m"
	sshpass -p "$PSW" ssh  $USER@$HOST "echo $PSW | sudo -S service pihole-FTL start"
	echo -e "Running command \e[96mpihole restartdns reload-lists\e[39m on \e[32m{$HOST}\e[39m"
	sshpass -p "$PSW" ssh  $USER@$HOST "echo $PSW | sudo -S pihole restartdns reload-lists"
}

# Print help if no argument is supplied
if [[ $# -eq 0 ]] ; then
   	print_help
    exit 0
fi

# Catch arguments
while getopts ":is" o
do
  case "$o" in
  i) process_install ;;
  s) process_sync ;;  
  *)
  esac
done;

