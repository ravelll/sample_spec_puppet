user { 'gussan':
  ensure => present,
  uid => 1000,
  gid => ['app_user','rbenv'],
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
