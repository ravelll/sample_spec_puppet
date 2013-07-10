class monit::config {
  file { '/etc/monit.conf':
    content => template('monit.conf'),
    mode    => '700',
  }

  file { '/etc/monit.d/unicorn.conf':
    content => template('unicorn'),
    mode    => '700',
  }
}
