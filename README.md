# PiHole Rsync
This script takes settings from a Master node of PiHole and syncs it to a Secondary PiHole. Check out my [blog post](https://jejje.net/2021-01-30-sync-two-pihole-dns-servers-for-failover)

## The Problem
Having only one DNS server will setup your home network to fail. It is best practice to have two separate DNS servers for a failover if the Primary fails or updates.
If you use your PiHole for local DNS names, you need to make sure both servers have the same records.

## The Solution
Using this script with RSYNC and Cronjobs it will sync files over from the Master Node to your secondary PiHole. All changes will propegate to your secondary PiHole. It's setup to run every 15 minutes but you can easily change it.

## Usage

This script requires RSYNC, SSHPASS and of course PiHole to be installed on the primary PiHole. Install dependencies if you do not have them already:
```shell
apt install rsync sshpass
```

In addition, RSYNC and PiHole must be installed on the secondary PiHole.

Download the script and make it executable:
```shell
cd /etc/pihole/
wget https://raw.githubusercontent.com/jejje/pihole-rsync/main/pi_rsync.sh
chmod +x pi_rsync.sh
```
You might get permission errors, because you might need sudo permission to write these changes.

Setup these variables first
```shell
#### Setup Vars ####
# What files to RSYNC
SYNCFILES=(gravity.db custom.list dhcp.leases local.list) 
# The Secondary PiHole Host
HOST=192.168.0.114
# Username on Secondary HOST
USER=pi
# Password on Secondary HOST
PSW=rasberry
# Update interval for CRONJOB
CRONTIME=15
```

Run this command only once to setup the cronjob. Afterwards it will run every 15 minutes.
```shell
./pi_rsync.sh -i
```

To run it manually and see that everything works, or if you want to do a forced update
```shell
./pi_rsync.sh -s
```

### Files that it syncs
It is setup to sync the db and some files. Just change the array if you want to to sync other files.

* gravity.db
* custom.list
* dhcp.leases
* local.list

```shell
SYNCFILES=(gravity.db custom.list dhcp.leases local.list) 
```

#### Credit
The idea for this code came from this pastebin [https://pastebin.com/KFzg7Uhi](https://pastebin.com/KFzg7Uhi)