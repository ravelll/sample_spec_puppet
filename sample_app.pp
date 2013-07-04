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
  'nginx',
  'monit'
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
  command => 'chmod -R g+rwxX rbenv',
}

exec { 'build_ruby_build':
  require => Exec['build_rbenv'],
  cwd     => '/usr/local',
  path    => '/usr/bin',
  command => 'git clone git://github.com/sstephenson/ruby-build.git ruby-build',
  creates => '/usr/local/ruby-build',
}

exec { 'install_ruby_build':
  require => Exec['build_ruby_build'],
  cwd     => '/usr/local/ruby-build',
  path    => '/bin',
  command => 'sh ./install.sh',
}

file { '/etc/profile.d/rbenv.sh':
  require => Exec['install_ruby_build'],
  content => template('rbenv_sh.erb'), 
}

exec { 'ruby_install':
  require => File['/etc/profile.d/rbenv.sh'],
  timeout => 0, 
  command => '/usr/local/rbenv/bin/rbenv install 2.0.0-p195',
  creates => '/usr/local/rbenv/versions/2.0.0-p195',
}

exec { 'rbenv_global':
  require => Exec['ruby_install'],
  command => '/usr/local/rbenv/bin/rbenv global 2.0.0-p195',
}

exec { 'rbenv_rehash_global':
  require => Exec['rbenv_global'],
  command => '/usr/local/rbenv/bin/rbenv rehash',
}

exec { 'install_bundler':
  require => Exec['rbenv_global'],
  command => '/usr/local/rbenv/shims/gem install bundler',
  create  => '/usr/local/rbenv/shims/bundle'
}

exec { 'rbenv_rehash_bundler':
  require => Exec['install_bundler'],
  command => '/usr/local/rbenv/bin/rbenv rehash',
}

service { 'nginx':
  require    => Package[$packages],
  enable     => true,
  ensure     => running,
  hasrestart => true, 
}

$port = 80
$app_root = '/home/gussan/rails_project/sample_app/public'
$server_name = 'app002.gussan.pb'

file { '/etc/nginx/conf.d/rails.conf':
  require => Exec['install_ruby_build'],
  content => template('rails_conf.erb'), 
}

service { 'mysqld':
  require    => Package[$packages], 
  enable     => true,
  ensure     => running,
  hasrestart => true,
}

exec { 'create_user_mysql':
  require => Service['mysqld'],
  path    => ['/usr/bin','/bin'],
  command => 'mysql -u root -e "grant select,alter,index,create,insert,update,delete on  *.* to \'gussan\'@\'localhost\' identified by \'gussan\';"',
#  unless  => 'mysql -u root -e "select User, Host from mysql.user where User=\'gussan\' and Host=\'localhost\'" | grep gussan',
}

exec { 'create_database':
  require => Exec['create_user_mysql'],
  path    => ['/usr/bin','/bin'],
  command => 'mysql -u root -e "create database sample_app;"',
  unless  => 'mysql -u root -e "show databases like \'sample_app\';" | grep sample_app'
}

file { '/var/run/unicorn/':
  ensure => directory,
  mode   => 777, 
}

file { '/var/log/unicorn/':
  ensure => directory,
  mode   => 777,
}

file { '/etc/monit.conf':
  require => Package[$packages],
  content => template('monit_conf.erb'), 
  mode    => 700,
}

file { '/etc/monit.d/unicorn.conf':
  require => File['/etc/monit.conf'],
  content => template('unicorn.erb'),
  mode    => 700,
}

service { 'monit':
  require    => File['/etc/monit.d/unicorn.conf'],
  enable     => true,
  ensure     => running,
  hasrestart => true, 
}

file { '/home/gussan/.ssh/authorized_keys':
  content => template('id_rsa_pub.erb'),
  owner   => 'gussan',
  mode    => 600,
}
