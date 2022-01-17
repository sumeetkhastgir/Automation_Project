#!/bin/bash

timestamp=$(date '+%d%m%Y-%H%M%S')
myname="sumeet"
s3_bucket="upgrad-sumeet/logs"

sudo apt update -y
sudo apt install apache2 -y

if [ `service apache2 status | grep running | wc -l` == 1 ]
then
	echo "Apache2 is running"
else
	echo "Apache2 is not running"
	echo "Starting apache2"
	sudo service apache2 start 

fi

if [ `service apache2 status | grep enabled | wc -l` == 1 ]
then
	echo "Apache2 is enabled"
else
	echo "Apache2 is not enabled"
	echo "Enabling apache2"
	sudo systemctl enable apache2
fi

echo "Compressing logs and storing into /tmp"

cd /var/log/apache2/

tar -cvf /tmp/${sumeet}-httpd-logs-${timestamp}.tar *.log

echo "Copying logs to s3"

aws s3 \
cp /tmp/${sumeet}-httpd-logs-${timestamp}.tar \
s3://${s3_bucket}/${sumeet}-httpd-logs-${timestamp}.tar

if [ -e /var/www/html/inventory.html ]
then
        echo "Inventory exists"
else
        touch /var/www/html/inventory.html
        echo "<b>Log Type &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Date Created &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Type &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Size</b>" >> /var/www/html/inventory.html
fi

echo "<br>httpd-logs &nbsp;&nbsp;&nbsp;&nbsp; ${timestamp} &nbsp;&nbsp;&nbsp;&nbsp; tar &nbsp;&nbsp;&nbsp;&nbsp; `du -h /tmp/${sumeet}-httpd-logs-${timestamp}.tar | awk '{print $1}'`" >> /var/www/html/inventory.html

if [ -e /etc/cron.d/automation ]
then
        echo "Cron job exists"
else
        touch /etc/cron.d/automation
        echo "0 0 * * * root /root/Automation_Project/automation.sh" > /etc/cron.d/automation
        echo "Cron job added"
fi
