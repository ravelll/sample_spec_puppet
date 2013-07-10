class common::sudoers {
  file { '/etc/sudoers':
    content => template('common/sudoers/sudoers'),
    mode    => '0440',
  }
}
