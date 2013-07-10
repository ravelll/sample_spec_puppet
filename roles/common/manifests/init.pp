class common {
  include common::packages
  include common::ssh_key
  include common::sudoers
  include common::user_group

    Class['common::user_group']
  ->Class['common::ssh_key']
  ->Class['common::packages']
  ->Class['sudoers']
}
