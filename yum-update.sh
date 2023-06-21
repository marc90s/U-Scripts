#!/bin/bash

#CREATED: 7/15/2022
#CREATED BY: Marc90s
#UPDATED: 8/22/2022
#AUTOMATES YUM UPDATES WITH --SECURITY AND --BUGFIX WILL CHECK IF SYSTEM REQUIRES A RESTART AND CONDUCT A RESTART.
#THIS SCRIPT SHOULD BE INVOKED BY USING THE UPDATE-START.SH LOCATED ON THE A REMOTE VM.
#REQ YUM-UTILS TO BE INSTALLED

YUM="yum update -y --security --bugfix"

echo -en '\n'
echo -en '\n'
echo "Starting the update for $HOSTNAME .................................."

if [ $? -eq 0 ] ; then

     sudo $YUM
   else
     echo Unable to update the system reason unknown
   exit 1
fi

if [ $? -eq 0 ] ; then

     sudo yum history | awk 'NR==4 {print $1}' | sudo yum history info >> /tmp/yum-update-$(date +%Y%m%d).info
     echo -en '\n'
     echo Generated a report in /tmp for tracking purposes If no updates were applied ignore the generated report.
   else
     echo Unable to Generate a Report
   exit 1
fi


echo -en '\n'
echo "Checking if reboot is required ................................."
echo -en '\n'

sudo needs-restarting -r

if [[ $? -eq 1 ]] ; then
   read -p "Do you wish to reboot the system now? (y/n):" yn
   case $yn in
        [Yy]* ) echo "Rebooting $HOSTNAME in 5 seconds" && sleep 5 && sudo reboot;;
        [Nn]* ) echo "Exiting ...."; exit;;
        * ) echo "Please answer with y or n." ;;
   esac
 else
   echo -en '\n'
   echo "No reboot required"
fi
