class mysql::install {
  $packages = [
  'mysql-devel',
  'mysql-libs',
  'mysql-server',
  ]

  package { $packages:
    ensure => installed,
  }
}
