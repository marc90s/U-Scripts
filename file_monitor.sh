#!/bin/bash

# Directory to monitor
DIRECTORY=     ##PICKUP DIRECTORY

# Destination directory for the tar file
DESTINATION_DIR= ##DROPOFF DIRECTORY

#hostname and user
USER=       #REMOTE USERNAME 
HOSTNAME=   #IPADDR/HOSTNAME


# Array to store the list of tarred files
declare -A tarred_files

# Find new files and process them
find "$DIRECTORY" -maxdepth 1 -type f -mmin -2 -not -name "*.tar" -not -name ".*" -print0
while IFS= read -r -d $'\0' file; do
    if [[ -z ${tarred_files[$file]} ]]; then
        echo "New file detected: $file"

        # Add your custom logic here to handle the new file
        timestamp=$(date +%Y%m%d%)
        tar_filename="${file}_$timestamp.tar"
        tar -cvf "$tar_filename" "$file"
        echo "File tarred: $tar_filename"
echo "                                                            "
        # Copy the tar file to the destination directory using scp
        scp "$tar_filename" $USER@$HOSTNAME:"$DESTINATION_DIR"
        echo "Tar file sent to $DESTINATION_DIR"

        # Remove the tar file from the DIRECTORY
        rm "$tar_filename"
        echo "Tar file removed: $tar_filename"

        # Mark the file as tarred
        tarred_files[$file]=1
    fi
done
