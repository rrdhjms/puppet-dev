class nfs_server {

  package { 'nfs-server':
    ensure          => installed,
  }

  service { 'nfs-server':
    require         => Package['nfs-server'],
    ensure          => running,
    enable          => true,
    hasrestart      => true,
  }

  file {  ['/srv','/srv/nfs', "/srv/nfs/${dir}"]:
    ensure          => 'directory',
    owner           => 'root',
    group           => 'root',
    mode            => '766',
  }

  file { '/etc/exports':
    ensure          => present,
  }

  file_line { 'nfs_line':
    require         => File['/etc/exports'],
    path            => '/etc/exports',
    line            => "/srv/nfs/${dir}   *(rw,sync,no_subtree_check,no_root_squash,no_all_squash,insecure)",
  }

  exec { 'exportfs -rav':
    provider        => shell,
    require         => File_line['nfs_line'],
    command         => 'exportfs -rav',
    notify          => Service['nfs-server'],
  }
}
