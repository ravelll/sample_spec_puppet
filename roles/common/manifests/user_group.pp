class common::user_group {
  user { 'gussan':
    ensure      => present,
    uid         => '1000',
    gid         => '1000',
    groups      => ['app_user','rbenv'],
    password    => 'gussan',
    comment     => 'gussan',
    home        => '/home/gussan',
    managehome  => true,
    shell       => '/bin/bash',
    require     => Group['rbenv'],
  }

  user { 'ravelll':
    groups      => 'rbenv',
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
    require     => Group['app_user'],
  }
}
