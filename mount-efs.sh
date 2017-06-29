#!/bin/bash
#
#Author:
#C L Lewis
#
#Date Creation:
#24.06.2017
#
#Version:
VER=1.0
#
#Aim:
#This is a script to automatically install:
#	-NFS-Utils
#	-Creates Mount Directory
#	-Sets Mount directory to be used with EFS
#
############################################
#Main Entry
############################################

sudo yum install -y nfs-utils

sudo mkdir -p /var/www/

sudo mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2 fs-7dae64b4.efs.eu-west-1.amazonaws.com:/ /var/www/html



