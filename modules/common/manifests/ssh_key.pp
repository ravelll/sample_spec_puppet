class common::ssh_key {
  file { '/home/gussan/.ssh/authorized_keys':
    content => template('id_rsa.pub'),
    owner   => 'gussan',
    mode    => '600',
  }
}
