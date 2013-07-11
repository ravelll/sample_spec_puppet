class monit::config {
  file { '/etc/monit.conf':
    content => template('monit/monit.conf'),
    mode    => '700',
  }
}
