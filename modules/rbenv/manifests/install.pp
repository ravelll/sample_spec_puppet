class rbenv::install {
  exec { 'build_rbenv':
    user        => 'root',
    cwd         => '/usr/local',
    path        => ['/bin', '/usr/bin'],
    command     => 'git clone git://github.com/sstephenson/rbenv.git rbenv',
    creates     => '/usr/local/rbenv',
    timeout     => 0,
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
}
