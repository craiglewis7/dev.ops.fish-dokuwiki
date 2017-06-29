#!/bin/bash
###########################################################################
#
# Script        : dokuwiki-ec2-install.sh
# Purpose       : Configure a Golden Image for an EC2 DokuWiki Instance and mount EFS Volume
# Authors       : Craig Lewis - http://dev.ops.fish
# History
# date         ver  who  what 
# -----------  ---  ---  ----------
# 27-Jun-2017  0.1  cll  Created the script towards the end of the night
##########################################################################
VERSION=0.1

##########################################################################
#
# MAIN
#
##########################################################################

#Installing epel-release as it contains the repo for nginx and awscli
sudo yum install -y epel-release

#With epel-release installed we can use yum to install nginx
sudo yum install -y nginx

#Start Nginx
sudo service nginx start

#Enable Nginx chkconfig
sudo chkconfig --levels 235 nginx on

#Installing PHP and additional PHP compentents as per dokuwiki prerequisites
sudo yum install -y php70-fpm.x86_64 php70-gd.x86_64 php70-json.x86_64 php70-cli.x86_64 php70-soap.x86_64 php70-tidy.x86_64 php70-xml.x86_64 php70-cli.x86_64 php70-common.x86_64 php7-pear.noarch php70.x86_64 php70-devel.x86_64 php70-pecl-apcu.x86_64

#Create a backup directory to store all backups of configuration files that we will edit
sudo mkdir -p /var/backups

#Originally the mehtod of using sites-available and sites-enabled with Nginx was going to be used.
#In the end I found a simpler way of configuring dokuwiki to Nginx and these directories are not needed.

#sudo mkdir -p /etc/nginx/sites-available &&  sudo touch /etc/nginx/sites-available/dokuwiki
#echo "#Don't forget to back me up once populated" >> /etc/nginx/sites-available/dokuwiki
#sudo mkdir -p /etc/nginx/sites-enabled
#sudo ln -s /etc/nginx/sites-available/dokuwiki /etc/nginx/sites-enabled/

#Create a backup file of /etc/nginx/nginx.comf
sudo touch /var/backups/nginx.bak && sudo cp -r /etc/nginx/nginx.conf /var/backups/nginx.bak

#Create a backup file of /etc/php-fpm.d/www.conf
sudo touch /var/backups/www.bak && sudo cp -r /etc/php-fpm.d/www.conf /var/backups/www.bak

#Create a backup file of /etc/php.ini
sudo touch /var/backups/php.bak && sudo cp -r /etc/php.ini /var/backups/php.bak

#Install the NFS-Utils as this is used to mount EFS
sudo yum install -y nfs-utils

#Ensure Nginx owns /var/www/html/dokuwiki
sudo chown -R nginx /var/www/html/dokuwiki
sudo chgrp -R nginx /var/www/html/dokuwiki

#Allow HTTP on Port 80 through the firewall
sudo iptables -A INPUT -p tcp -m tcp --dport 80 -j ACCEPT

#All SSH on Port 22 through the firewall
sudo iptables -A INPUT -p tcp -m tcp --dport 22 -j ACCEPT

#Save the IPTables
sudo service iptables save

#Restart the IPTables
sudo service iptables restart

echo "You need to edit php.ini"

echo "You need to edit nginx.conf"

echo "You need to edit www.conf"

echo "You need to populate default.conf"

echo "Restarting PHP-FPM"

#Restart PHP-FPM Service
sudo service php-fpm restart

echo "Restarting Nginx"

#Restart Nginx Service
sudo service nginx restart

#Ensure that the EFS is mounted to the Instance
sudo mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2 fs-7dae64b4.efs.eu-west-1.amazonaws.com:/ /var/www/html

