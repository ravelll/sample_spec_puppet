class nginx::config {
  $port = 80
  $app_root = '/home/gussan/rails_project/sample_app/current/public'
  $server_name = 'app002.gussan.pb'  
  
  file { '/etc/nginx/conf.d/rails.conf':
      content => template('rails.conf'), 
    }
}
