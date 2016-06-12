#!/bin/bash -v
yum install -y httpd
service iptables stop
chkconfig --level 235 iptables stop
service httpd start
