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

group { 'app_user':
  ensure => present,
  gid => 1000,
}

group { 'rbenv':
  ensure => present,
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
  'gcc-c++'
]

package { $packages:
  ensure => installed,
}
