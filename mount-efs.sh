#!/bin/bash
###########################################################################
#
# Script        : mount-efs.sh
# Purpose       : Basic script to mount EFS into EC2 Instance
# Authors       : Craig Lewis - http://dev.ops.fish
# History
# date         ver  who  what 
# -----------  ---  ---  ----------
# 28-Jun-2017  0.1  cll  Created the script towards the end of the night
##########################################################################
VERSION=0.1

##########################################################################
#
# MAIN
#
##########################################################################

sudo yum install -y nfs-utils

sudo mkdir -p /var/www/html

sudo mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2 fs-7dae64b4.efs.eu-west-1.amazonaws.com:/ /var/www/html