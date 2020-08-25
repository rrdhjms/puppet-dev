node default {
  include profile::server
}

node nfs {
  $dir = "jenkins"
  include role::nfs_server
}

node nexus {
  include role::nexus_server
}

node logger {
  include role::logging_server
}
