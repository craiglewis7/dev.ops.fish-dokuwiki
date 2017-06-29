#!/bin/bash
###########################################################################
#
# Script        : backup-to-s3.sh
# Purpose       : Backs up all data for the DokuWiki Site to an S3 Bucket
# Authors       : Craig Lewis - http://dev.ops.fish
# History
# date         ver  who  what 
# -----------  ---  ---  ----------
# 27-Jun-2017  0.1  cll  Created the script towards the end of the night
##########################################################################
VERSION=0.1

##########################################################################
#
# Varianbles
#
##########################################################################

BAKTIME=$(date +"%y-%m-%d-%H%M%S")
BAKFILE="full_backup_$BAKTIME.tar.gz"
BUCKET="s3://dev-ops-fish"

##########################################################################
#
# MAIN
#
##########################################################################

echo "backup to file: $BAKFILE"

#Zip all the dokuwiki data files that need backing up to S3 
echo "backing up files..."
cd /var/backups/dokuwiki
sudo tar czf "$BAKFILE" /var/www/html/dokuwiki --exclude='.git'

#Move the .zip backup to the backup directory 
#echo "moving backup..."
#sudo find /var/www/html/full_backup_* -type f -exec mv {} /var/backups/dokuwiki ;
 
#Change directoty to where the backups are stored
echo "moving to safe place..."
cd /var/backups/dokuwiki

#Delete any old backups that exist, ensuring we only backup the latest 
echo "cleanup old backups..."
sudo find /var/backups/dokuwiki/full_backup_* -type f -mtime +3 -exec rm {} ;
 
#Using the awscli, back data into S3 bucket
echo "uploading new file to S3..."
/usr/bin/aws s3 cp "/var/backups/dokuwiki/$BAKFILE" $BUCKET

echo "finished!"

#Verify backed up to S3
aws s3 ls $BUCKET