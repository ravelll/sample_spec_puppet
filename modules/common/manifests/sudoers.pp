class common::sudoers {
  file { '/etc/sudoers':
    content => template('sudoers'),
    mode    => '0440',
  }
}
