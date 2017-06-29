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

sudo yum install -y epel-release

sudo yum install -y nginx

sudo service nginx start

sudo chkconfig --levels 235 nginx on

sudo yum install -y php70-fpm.x86_64 php70-gd.x86_64 php70-json.x86_64 php70-cli.x86_64 php70-soap.x86_64 php70-tidy.x86_64 php70-xml.x86_64 php70-cli.x86_64 php70-common.x86_64 php7-pear.noarch php70.x86_64 php70-devel.x86_64 php70-pecl-apcu.x86_64

sudo mkdir -p /var/backups

#sudo mkdir -p /etc/nginx/sites-available &&  sudo touch /etc/nginx/sites-available/dokuwiki

#echo "#Don't forget to back me up once populated" >> /etc/nginx/sites-available/dokuwiki

#sudo mkdir -p /etc/nginx/sites-enabled

#sudo ln -s /etc/nginx/sites-available/dokuwiki /etc/nginx/sites-enabled/

sudo touch /var/backups/nginx.bak && sudo cp -r /etc/nginx/nginx.conf /var/backups/nginx.bak

sudo touch /var/backups/www.bak && sudo cp -r /etc/php-fpm.d/www.conf /var/backups/www.bak

sudo touch /var/backups/php.bak && sudo cp -r /etc/php.ini /var/backups/php.bak

#sudo touch /etc/nginx/conf.d/default.conf && echo "#Don't forget to back me up once populated" >> /etc/nginx/conf.d/default.conf

sudo yum install -y nfs-utils

#sudo mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2 fs-7dae64b4.efs.eu-west-1.amazonaws.com:/ /var/www/html

sudo chown -R nginx /var/www/html/dokuwiki

sudo chgrp -R nginx /var/www/html/dokuwiki

sudo iptables -A INPUT -p tcp -m tcp --dport 80 -j ACCEPT

sudo iptables -A INPUT -p tcp -m tcp --dport 22 -j ACCEPT

sudo service iptables save

sudo service iptables restart

echo "You need to edit php.ini"

echo "You need to edit nginx.conf"

echo "You need to edit www.conf"

echo "You need to populate default.conf"

echo "Restarting PHP-FPM"

sudo service php-fpm restart

echo "Restarting Nginx"

sudo service nginx restart

sudo mount -t nfs4 -o nfsvers=4.1,rsize=1048576,wsize=1048576,hard,timeo=600,retrans=2 fs-7dae64b4.efs.eu-west-1.amazonaws.com:/ /var/www/html

