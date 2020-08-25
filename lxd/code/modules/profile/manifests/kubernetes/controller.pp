# @summary A short summary of the purpose of this class
#
# A description of what this class does
#
# @example
#   include profile::kubernetes::controller
class profile::kubernetes::controller {
      if $facts['virtual'] == 'lxc' {
            file { '/dev/kmsg':
      	    	   ensure => 'link',
	   	   target => '/dev/console',
      		 }
      }
      package {'conntrack': ensure => installed}
      class {'kubernetes':
            controller => true,
	    require => Package['conntrack'],
      }
      Package['conntrack'] -> Class['kubernetes']
      if $facts['virtual'] == 'lxc' {
      	 File['/dev/kmsg'] -> Class['kubernetes']
      }
}
