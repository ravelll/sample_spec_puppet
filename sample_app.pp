user { 'gussan':
  ensure => present,
  uid => 1000,
  gid => 1000,
  groups => ['rbenv','app_user'],
  password => 'gussan',
  comment => 'gussan',
  home => '/home/gussan',
  managehome => true,
  shell => '/bin/bash',
}

file { '/home/gussan':
  require => User['gussan'],
  mode    => 755,
}

group { 'app_user':
  ensure => present,
  gid => 1000,
}

file { '/etc/sudoers':
  require => User['gussan'],
  content => template('sudoers.erb'),
  mode    => 440
}

$packages = [
  'zlib-devel',
  'readline-devel',
  'ncurses-devel',
  'gdbm-devel',
  'db4-devel',
  'libffi-devel',
  'tk-devel',
  'libyaml-devel',
  'make',
  'gcc',
  'gcc-c++',
  'mysql-devel',
  'mysql-libs',
  'mysql-server',
  'nginx',
  'monit',
  'memcached',
  'nc'
]

package { $packages:
  ensure => installed,
}

file { '/var/run/unicorn/':
  ensure => directory,
  mode   => 777, 
}

file { '/var/log/unicorn/':
  ensure => directory,
  mode   => 777,
}

file { '/home/gussan/.ssh/authorized_keys':
  content => template('id_rsa_pub.erb'),
  owner   => 'gussan',
  mode    => 600,
}
