class mysql {
  include mysql::install
  include mysql::config
  include mysql::service

  Class['mysql::install']
  ->Class['mysql::service']
  ->Class['mysql::config']
}
