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
  'gcc',
  'gcc-c++',
  'mysql-devel',
  'mysql-libs',
  'mysql-server',
  'nginx'
]

package { $packages:
  ensure => installed,
}

exec { 'build_rbenv':
  user        => 'root',
  cwd         => '/usr/local',
  path        => ['/bin', '/usr/bin'],
  command     => 'git clone git://github.com/sstephenson/rbenv.git rbenv',
  creates     => '/usr/local/rbenv',
  timeout     => 0,
  require     => Package[$packages],
}

exec { 'chgrp_rbenv':
  require => Exec['build_rbenv'],
  cwd     => '/usr/local',
  path    => '/bin',  
  command => 'chgrp -R rbenv rbenv',    
}

exec { 'chmod_rbenv':
  require => Exec['chgrp_rbenv'],
  cwd     => '/usr/local',
  path    => '/bin',  
  command => 'chmod -R g+rwxXs rbenv',
}

exec { 'build_ruby_build':
  require => Exec['build_rbenv'],
  cwd     => '/usr/local',
  path    => '/usr/bin',
  command => 'git clone git://github.com/sstephenson/ruby-build.git ruby-build',
  creates => '/usr/local/ruby-build',
}
