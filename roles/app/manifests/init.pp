class app {
  include app::common
  include app::ruby
  include app::mysql
  include app::monit
  include app::memcached
  include app::nginx
  include app::unicorn

    Class['app::common']
  ->Class['app::ruby']
  ->Class['app::mysql']
  ->Class['app::nginx']
  ->Class['app::unicorn']
  ->Class['app::memcached']
  ->Class['app::monit']
}
