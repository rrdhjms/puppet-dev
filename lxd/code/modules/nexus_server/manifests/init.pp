class nexus_server {
  include 'docker'

  docker_volume { 'nexus-data':
    ensure        => present,
  }

  docker::run { 'nexus':
    image         => 'sonatype/nexus3',
    restart       => 'always',
    ports         => ['80:8081'],
    volumes       => ['nexus-data:/nexus-data']
  }
}
