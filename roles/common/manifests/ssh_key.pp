class common::ssh_key {
  file { '/home/gussan/.ssh':
    ensure => directory,
    owner   => 'gussan',
    group   => 'app_user',
    mode    => '0700',
  }

  file { '/home/gussan/.ssh/authorized_keys':
    content => template('common/ssh-key/id_rsa.pub'),
    owner   => 'gussan',
    mode    => '600',
  }
}
