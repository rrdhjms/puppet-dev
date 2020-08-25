#!/bin/bash

sudo dnf update -y
sudo dnf install git nano ntpdate -y
sudo ntpdate 0.centos.pool.ntp.org
sudo systemctl start ntpd
sudo systemctl enable ntpd
sudo dnf install https://yum.puppetlabs.com/puppet-release-el-8.noarch.rpm -y

sudo dnf install puppetserver -y

sudo sed -i 's/JAVA_ARGS="-Xms2g -Xmx2g/JAVA_ARGS="-Xms500m -Xmx500m/' /etc/sysconfig/puppetserver

sudo echo 'dns_alt_names = puppet

[main]
certname = puppet
server = puppet
environment = production
runinterval = 15m

[agent]
runinterval = 15m' >> /etc/puppetlabs/puppet/puppet.conf

sudo systemctl start puppetserver
sudo systemctl enable puppetserver

echo 'PATH=$PATH:/opt/puppetlabs/bin/puppetserver' >> /etc/profile

