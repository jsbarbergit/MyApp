#!/bin/bash -v
yum install -y httpd
#Observed failure of initial yum install with a timeout (possibly caused by NAT Gateway not being up yet
if [ $? -ne 0 ]; then 
	sleep 30;
	yum install -y httpd
fi
service iptables stop
chkconfig --level 235 iptables stop
echo "MyApp-DEV-Test" > /var/www/html/index.html
chown apache:apache /var/www/html/index.html
service httpd start
