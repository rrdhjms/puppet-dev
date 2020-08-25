class log_server {
  include 'docker'

  file { '/etc/prometheus':
    ensure          => 'directory',
    owner           => 'root',
    group           => 'root',
    mode            => '744',
  }

  file { '/etc/prometheus/prometheus.yml':
    require     => File['/etc/prometheus'],
    ensure      => file,
    group       => 'root',
    owner       => 'root',
    mode        => '666',
    source      => "puppet:///modules/prometheus/prometheus.yml",
  }

  file { '/etc/prometheus/docker-compose.yml':
    require     => File['/etc/prometheus/prometheus.yml'],
    ensure      => file,
    group       => 'root',
    owner       => 'root',
    source      => "puppet:///modules/prometheus/docker-compose.yml",
  }

  class {'docker::compose':
    ensure          => present,
    version         => '1.17.1',
  }

  docker_compose { 'logging_server':
    require         => File['/etc/prometheus/docker-compose.yml'],
    compose_files   => ['/etc/prometheus/docker-compose.yml'],
    ensure          => present,
  }
}
