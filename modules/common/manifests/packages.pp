class common::packages {
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
    'nc',
  ]

  package { $packages:
    ensure => installed,
  }
}
