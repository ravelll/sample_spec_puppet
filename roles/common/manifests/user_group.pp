class common::user_group {
  user { 'gussan':
    ensure      => present,
    uid         => '1000',
    gid         => '1000',
    groups      => 'app_user',
    password    => 'gussan',
    comment     => 'gussan',
    home        => '/home/gussan',
    managehome  => true,
    shell       => '/bin/bash',
  }

  file  { '/home/gussan':
    require     => User['gussan'],
    mode        => '0755',
  }

  group { 'app_user':
    ensure      => present,
    gid         => '1000',
  }
}
