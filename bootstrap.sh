#!/bin/bash

#Adding the user to the cluter
useradd  -mG wheel cloudera
echo itversity | passwd cloudera --stdin
sed -i "s/PasswordAuthentication no/PasswordAuthentication yes/g" /etc/ssh/sshd_config
service sshd restart

sudo service iptables stop
sudo chkconfig iptables off
sudo setenforce 0

sudo service firewalld stop

#Disable selinux permanently
sudo sed -i 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config
sudo sed -i 's/SELINUX=permissive/SELINUX=disabled/g' /etc/selinux/config

#Increase file limits
sudo sh -c 'echo "* soft nofile 10000" >> /etc/security/limits.conf'
sudo sh -c 'echo "* hard nofile 10000" >> /etc/security/limits.conf'

#Uncommenting the sudoers file
sudo sed -i '/NOPASSWD/s/^#//g' /etc/sudoers

#Change Swappiness
sudo /bin/sh -c 'sudo echo "vm.swappiness = 1" >> /etc/sysctl.conf'
sudo sysctl vm.swappiness=1

#Disable Transaparent Hue Pages
sudo sh -c 'echo never > /sys/kernel/mm/transparent_hugepage/defrag'
sudo sh -c 'echo never > /sys/kernel/mm/transparent_hugepage/enabled'

#Copying required files
sudo cp /vagrant/adddisks.sh /opt/adddisks.sh
sudo cp /etc/hosts /etc/hosts.bkp
sudo cp /vagrant/hosts /etc/hosts
sudo cp /etc/profile /etc/profile.bkp
sudo cp /vagrant/profile /etc/profile
sudo cp /vagrant/cloudera-manager.repo /etc/yum.repos.d/cloudera-manager.repo
sudo cp /vagrant/cloudera-cdh5.repo /etc/yum.repos.d/cloudera-cdh5.repo
sudo cp /vagrant/jdk-8u131-linux-x64.rpm /opt/jdk-8u131-linux-x64.rpm
sudo cp /vagrant/main.sh /opt/main.sh 

sudo chmod +x /opt/adddisk.sh
bash /opt/adddisks.sh


sudo yum -y install wget
sudo yum install ntp -y
sudo systemctl enable ntpd
sudo systemctl start ntpd


sudo rpm -ivh /opt/jdk-8u131-linux-x64.rpm





