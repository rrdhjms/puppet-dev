class jenkins_server {
  include 'docker' 

  package { 'nfs-common':
    ensure     => 'installed',
  }

  file { '/etc/jenkins':
    ensure     => 'directory',
    owner      => 'root',
    group      => 'root',
    mode       => '744',
  }

  file { '/etc/jenkins/docker-compose.yml':
    require    => File['/etc/jenkins'],
    ensure     => file,
    owner      => 'root',
    group      => 'root',
    mode       => '766',
    source     => "puppet:///modules/jenkins/docker-compose.yml",
  }

  class {'docker::compose':
    ensure          => present,
    version         => '1.17.1',
  }

  docker_compose { 'jenkins':
    require    => File['/etc/jenkins/docker-compose.yml'],
    compose_files => ['/etc/jenkins/docker-compose.yml'],
    ensure     => present,
  }

  #docker_volume { 'jenkins_volume':
  #  require    => Package['nfs-common'],
  #  ensure     => 'present',
  #  driver     => 'local',
  #  options    => ['type=nfs','o=addr=172.1.0.14,rw', 'device=:/srv/nfs/jenkins'],
  #}

  #docker::run { 'jenkins':
  #  image     => 'jenkins/jenkins:latest',
  #  restart   => 'unless-stopped',
  #  ports     => ['8080:8080','50000:50000'],
  #  volumes   => ['jenkins_volume:/var/jenkins_home'],
  #}
}
