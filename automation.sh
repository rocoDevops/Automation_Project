i#!/bin/bash
s3_bucket="upgrad-chandan"
name="Chandan"

apt update -y

apt install apache2 -y

systemctl start apache2
systemctl enable apache2

timestamp=$(date '+%d%m%Y-%H%M%S')
tar -cvf /tmp/${name}-httpd-logs-${timestamp}.tar /var/log/apache2/access.log

aws s3 cp /tmp/${name}-httpd-logs-${timestamp}.tar s3://${s3_bucket}/${name}-httpd-logs-${timestap}.tar


inventory_file="/var/www/html/inventory.html"
if [ -e $inventory_file ]
then
    echo "inventory.html file exist"
    file_size=$(ls -lh /tmp/${name}-httpd-logs-${timestamp}.tar | awk '{ print $5}')
    printf "httpd-logs $timestamp tar $file_size \n" >> $inventory_file
    echo "logs added to the inventory file"

else
    echo "inventory.html file doesnot exist,generating inventory.html file"
    file_size=$(ls -lh /tmp/${name}-httpd-logs-${timestamp}.tar  | awk '{ print $5}')
    printf "httpd-logs $timestamp tar $file_size \n" >> $inventory_file
    echo "log file extractions are added to the inventory.html file"
fi


automate_cron_job="/etc/cron.d/automation"
if [  -f $automate_cron_job ]
then
    echo "cron file for automation exist"
else
echo "cron job needs to be created,creating a cron job"
    printf "* * * * * root /root/Automation_Project/automation.sh\n" > $automate_cron_job
fi

