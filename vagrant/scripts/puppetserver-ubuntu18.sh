#!/bin/bash

PUPPET_IP=$1
HOST_NAME=$2

cd /tmp
wget https://apt.puppetlabs.com/puppet6-release-bionic.deb
sudo dpkg -i puppet6-release-bionic.deb
sudo apt update

sudo apt install puppetserver -y

sudo sed -i 's/JAVA_ARGS="-Xms2g -Xmx2g/JAVA_ARGS="-Xms512m -Xmx512m/' /etc/default/puppetserver

sudo echo "dns_alt_names = puppet

[main]
certname = ${HOST_NAME}
server = puppet
environment = production
runinterval = 15m

[agent]
runinterval = 15m" >> /etc/puppetlabs/puppet/puppet.conf



sudo systemctl start puppetserver
sudo systemctl enable puppetserver