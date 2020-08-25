class node_exporter {
  include ::systemd::daemon_reload

  $group          = 'node_exporter'
  $username       = $group

  $servicefile = "[Unit]
Description=Node Exporter
After=network.target

[Service]
User=node_exporter
Group=node_exporter
Type=simple
ExecStart=/usr/local/bin/node_exporter

[Install]
WantedBy=multi-user.target
"

  group { $group:
    ensure      => present,
    gid         => 2000,
  }

  user { $username:
    ensure      => present,
    gid         => $group,
    require     => Group[$group],
    uid         => 2000,
    managehome  => false,
    shell       => "/bin/false",
  }

  file { '/etc/systemd/system/node_exporter.service':
    ensure      => file,
    group       => $group,
    owner       => $username,
    mode        => '0777',
    content     => $servicefile
  }

  file { '/tmp/node_exporter-1.0.0.linux-amd64.tar.gz':
    group       => $group,
    owner       => $username,
    mode        => '0777',
  }

  archive { 'node_exporter-1.0.0.linux-amd64.tar.gz':
    path        => "/tmp/node_exporter-1.0.0.linux-amd64.tar.gz",
    source      => "https://github.com/prometheus/node_exporter/releases/download/v1.0.0/node_exporter-1.0.0.linux-amd64.tar.gz",
    extract     => true,
    extract_path=> "/tmp",
  }

  file { '/usr/local/bin/node_exporter':
    ensure      => present,
    require     => Archive['node_exporter-1.0.0.linux-amd64.tar.gz'],
    source      => "/tmp/node_exporter-1.0.0.linux-amd64/node_exporter",
    mode        => '0700',
    owner       => $username,
    group       => $group,
    notify      => [
                Class['systemd::daemon_reload'],
                Service['node_exporter'],
                ],
  }

  service { "node_exporter":
    require     => Class['systemd::daemon_reload'],
    ensure      => running,
    enable      => true,
  }
}
