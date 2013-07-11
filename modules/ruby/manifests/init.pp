class ruby {
  include ruby::install
  include ruby::config

  Class['ruby::install']
  ->Class['ruby::config']
}
