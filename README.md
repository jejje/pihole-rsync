# PiHole Rsync
This script takes settings from a Master node of PiHole and syncs it to a Secondary PiHole.

## The Problem
Having only one DNS server will setup your home network to fail. It's is best practice to have two seperate DNS servers for a failover if the Primary fails or updates.
If you use your PiHole for local DNS names, you need to make sure both servers have the same records.

## The Solution
Using this script with RSYNC and Cronjobs it will sync files over from the Master Node to your secondary PiHole. All changes will propegate to your secondary PiHole. It's setup to run every 15 minutes but you can easily change it.

## Usage

Setup these variables first
```shell
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
```

Run this command once to setup the cronjob, and it will run every 15 minutes.
```shell
./pi_rsync.sh -i
```

To run it manually and see that everything works
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