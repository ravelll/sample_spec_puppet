class db {
  include db::common
  include db::mysql

    Class['db::common']
  ->Class['db::mysql']
}
