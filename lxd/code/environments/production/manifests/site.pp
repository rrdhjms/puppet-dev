node default {
  include profile::server
}

node node-01 {
  $ip_address = "172.1.0.20/24"
  include role::kubernetes::controller
  #include profile::hiera_test
}

node nfs {
  $dir = "jenkins"
  $ip_address = "172.1.0.14/24"
  include role::nfs_server
}

node nexus {
  $ip_address = "172.1.0.13/24"
  include role::nexus_server
}

node logger {
  $ip_address = "172.1.0.11/24"
  include role::logging_server
}

node jenkins {
  $ip_address = "172.1.0.40/24"
  include profile::base
  include profile::server
  include profile::jenkins
}
