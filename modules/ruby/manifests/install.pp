class ruby::install {
  exec { 'build_rbenv':
    user        => 'root',
    cwd         => '/usr/local',
    path        => ['/bin', '/usr/bin'],
    command     => 'git clone git://github.com/sstephenson/rbenv.git rbenv',
    creates     => '/usr/local/rbenv',
    timeout     => 0,
  }

  exec { 'chgrp_rbenv':
    user    => 'root',
    require => Exec['build_rbenv'],
    cwd     => '/usr/local',
    path    => '/bin',  
    command => 'chgrp -R rbenv rbenv', 
  }

  exec { 'chmod_rbenv':
    user    => 'root',
    require => Exec['chgrp_rbenv'],
    cwd     => '/usr/local',
    path    => '/bin',  
    command => 'chmod -R g+rwxX rbenv',
  }

  exec { 'build_ruby_build':
    user    => 'root',
    require => Exec['chmod_rbenv'],
    cwd     => '/usr/local',
    path    => '/usr/bin',
    command => 'git clone git://github.com/sstephenson/ruby-build.git ruby-build',
    creates => '/usr/local/ruby-build',
  }

  exec { 'install_ruby_build':
    user    => 'root',
    require => Exec['build_ruby_build'],
    cwd     => '/usr/local/ruby-build',
    path    => '/bin',
    command => 'sh ./install.sh',
  }

  file { '/etc/profile.d/rbenv.sh':
    user    => 'root',
    require => Exec['install_ruby_build'],
    content => template('ruby/rbenv.sh'), 
  }

  exec { 'ruby_install':
    user    => 'root',
    require => File['/etc/profile.d/rbenv.sh'],
    timeout => 0,
    command => '/usr/local/rbenv/bin/rbenv install 2.0.0-p195',
    creates => '/usr/local/rbenv/versions/2.0.0-p195',
  }

  exec { 'rbenv_global':
    user    => 'root',
    require => Exec['ruby_install'],
    command => '/usr/local/rbenv/bin/rbenv global 2.0.0-p195',
  }

  exec { 'rbenv_rehash_global':
    user    => 'root',    
    require => Exec['rbenv_global'],
    command => '/usr/local/rbenv/bin/rbenv rehash',
  }

  exec { 'install_bundler':
    require => Exec['rbenv_global'],
    user    => 'root',
    command => '/usr/local/rbenv/shims/gem install bundler',
  }

  exec { 'rbenv_rehash_bundler':
    require => Exec['install_bundler'],
    user    => 'root',
    command => '/usr/local/rbenv/bin/rbenv rehash',
  }
}
