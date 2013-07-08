class mysql::config{
  exec { 'create_user_mysql':
    path    => ['/usr/bin','/bin'],
    command => 'mysql -u root -e "grant 
      select, alter, create, drop, delete, insert, update, index 
      on *.* to \'gussan\'@\'%\' identified by \'gussan\';"'
  }

  exec { 'create_database':
    require => Exec['create_user_mysql'],
    path    => ['/usr/bin','/bin'],
    command => 'mysql -u gussan -e "create database sample_app;"',
    unless  => 'mysql -u gussan -e "show databases like \'sample_app\';" | grep sample_app'
  }
}
