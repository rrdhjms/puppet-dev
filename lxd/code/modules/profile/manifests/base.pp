# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include profile::base
class profile::base {
  class { 'netplan':
    config_file   => '/etc/netplan/01-custom.yaml',
    ethernets     => {
      'eth0' => {
        'dhcp4' => false,
        'addresses' => [$ip_address],
        'gateway4' => '172.1.0.1',
	'nameservers' => {
	  'addresses' => ['172.1.0.1'],
	}
      }
    },
    netplan_apply => true,
  }

  # Install virt-what so that we get a virtual fact on the next run
  # Rebooting at this point seems sensible
  if $facts['os']['family'] == 'Debian' {
     package { 'virt-what':
     	    ensure => installed
     }

     reboot { 'after': subscribe =>  Package['virt-what'] }
  }
}
