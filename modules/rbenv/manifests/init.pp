class rbenv {
  include rbenv::install
  include rbenv::config

  Class['rbenv::install']
  ->Class['rbenv::config']
}
