class ssh_authorize::config {
  $ssh_key_path = '/home/gussan/.ssh/authorized_keys'

  file { $ssh_key_path:
    content => template('id_rsa.pub'),
    owner   => 'gussan',
    mode    => '600',
  }
}
