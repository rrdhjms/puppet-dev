class role::nfs_server {
  include profile::base
  include profile::server
  include profile::nfs_server
}
