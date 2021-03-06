class mysql::config{
  exec { 'create_user_out':
    path    => ['/usr/bin','/bin'],
    command => 'mysql -u root -e "grant 
      select, alter, create, drop, delete, insert, update, index 
      on *.* to \'gussan\'@\'%\' identified by \'gussan\';"'
  }

  exec { 'create_user_local':
    path    => ['/usr/bin','/bin'],
    command => 'mysql -u root -e "grant 
      select, alter, create, drop, delete, insert, update, index 
      on *.* to \'gussan\'@\'localhost\';"'
  }

  exec { 'create_database':
    require => Exec['create_user_local'],
    path    => ['/usr/bin','/bin'],
    command => 'mysql -u gussan -e "create database sample_app;"',
    unless  => 'mysql -u gussan -e "show databases like \'sample_app\';" | grep sample_app'
  }

  exec { 'set_user_password':
    require => Exec['create_database'],
    path    => ['/usr/bin','/bin'],
    command => 'mysql -u root -e "set password for gussan=password(\'gussan\');"',
  }
}
