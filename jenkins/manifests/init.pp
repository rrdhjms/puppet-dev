class jenkins_server {
  include 'docker'

  package { 'nfs-common':
    ensure     => 'installed',
  }

  docker_volume { 'jenkins_volume':
    require    => Package['nfs-common'],
    ensure     => 'present',
    driver     => 'local',
    options    => ['type=nfs','o=addr=172.31.0.14',rw, 'device=:/srv/nfs/jenkins'],
  }

  docker::run { 'jenkins':
    require   => Docker_volume['jenkins_volume'],
    image     => 'jenkins/jenkins:latest',
    restart   => 'unless-stopped',
    ports     => ['8080:8080','50000:50000'],
    volumes   => ['jenkins_volume:/var/jenkins_home'],
  }
}


