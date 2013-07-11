class ruby::install {
  group { 'rbenv':
    ensure  => present,
  }

  user { 'gussan':
    group   => 'rbenv',
    require => Group['rbenv'],
  }

  user { 'ravelll':
    group   => 'rbenv',
    require => Group['rbenv'],
  }

  exec { 'build_rbenv':
    user        => 'root',
    cwd         => '/usr/local',
    path        => ['/bin', '/usr/bin'],
    command     => 'git clone git://github.com/sstephenson/rbenv.git rbenv',
    creates     => '/usr/local/rbenv',
    require     => Exec['chmod_rbenv'],
    timeout     => 0,
  }

  exec { 'chgrp_rbenv':
    require => Group['rbenv'],
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
    content => template('ruby/rbenv.sh'), 
  }

  exec { 'ruby_install':
    require => File['/etc/profile.d/rbenv.sh'],
    timeout => 0,
    user    => 'root',
    command => '/usr/local/rbenv/bin/rbenv install 2.0.0-p195',
    creates => '/usr/local/rbenv/versions/2.0.0-p195',
  }

  exec { 'rbenv_global':
    require => Exec['ruby_install'],
    user    => 'root',
    command => '/usr/local/rbenv/bin/rbenv global 2.0.0-p195',
  }

  exec { 'rbenv_rehash_global':
    require => Exec['rbenv_global'],
    user    => 'root',
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
