class common::user_group {
  user { 'gussan':
    ensure      => present,
    uid         => '1000',
    gid         => '1000',
    groups      => ['rbenv','app_user'],
    password    => 'gussan',
    comment     => 'gussan',
    home        => '/home/gussan',
    managehome  => true,
    shell       => '/bin/bash',
    require     => Group['rbenv'],
  }

  file  { '/home/gussan':
    require     => User['gussan'],
    mode        => '0755',
  }

  group { 'app_user':
    ensure      => present,
    gid         => '1000',
  }

  group { 'rbenv':
    ensure      => present,
    path        => ['/usr/bin','/bin'],
    require     => Group['app_user'],
    unless      => 'less /etc/group | grep rbenv',
  }
}
