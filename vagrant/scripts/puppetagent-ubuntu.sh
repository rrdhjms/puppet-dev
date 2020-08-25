PUPPET_IP=$1
HOST_NAME=$2

echo $PUPPET_IP puppet >> /etc/hosts
sudo wget http://apt.puppetlabs.com/puppetlabs-release-trusty.deb
sudo dpkg -i puppetlabs-release-trusty.deb
sudo apt-get update
sudo apt-get install puppet -y
sudo sed -i "/\[main\\]/ a certname = ${HOST_NAME}\nserver = puppet\nenvironment = production\nruninterval = 15m" /etc/puppet/puppet.conf
sudo systemctl start puppet
sudo systemctl enable puppet