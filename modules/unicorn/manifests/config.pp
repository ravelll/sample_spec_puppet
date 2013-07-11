class unicorn::config {
  file { '/var/run/unicorn':
    ensure  => directory,
    mode    => '0755',
  }

  file { '/var/log/unicorn':
    ensure  => directory,
    mode    => '0755',
  }

  file { '/etc/monit.d/unicorn.conf':
    content => template('unicorn/unicorn.conf'),
  }
}
