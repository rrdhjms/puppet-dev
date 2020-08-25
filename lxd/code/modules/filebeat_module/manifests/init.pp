class filebeat_module {

  class { 'filebeat':
    outputs => {
      'elasticsearch' => {
        'hosts' => [
          'http://localhost:9200',
          'http://172.1.0.11:9200'
        ],
        'loadbalance' => true,
        'cas'         => [
          '/etc/pki/root/ca.pem',
        ],
      }
    }
  }

  filebeat::input { 'syslogs':
    paths    => [
      '/var/log/auth.log',
      '/var/log/syslog',
    ],
    doc_type => 'syslog-beat',
  }

}
