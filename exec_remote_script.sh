#!/bin/bash

#Checking if host is running 

hosts=("10.13.10.127" "10.13.10.115")

for vm in "${hosts[@]}"; do ping -c 3 $vm >/dev/null 2>&1 ; done

if [ $? -ne 0 ] ; then 

   echo "$HOSTNAME is not reachable"
else
   echo "$HOSTNAME is reachable"
   for vm in "${hosts[@]}"; do ssh -qt admin@$vm exec "sudo /home/admin/remote_script_example.sh"; done # starts scripts on remote hosts
fi
