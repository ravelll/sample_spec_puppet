class nginx::install {
  package { 'nginx':
    ensure => installed
  }
  
  file { '/var/log/nginx':
    ensure  => directory,
    owner   => 'nginx',
    group   => 'nginx',
    mode    => '0755',
    require => Package['nginx']
  }
}
