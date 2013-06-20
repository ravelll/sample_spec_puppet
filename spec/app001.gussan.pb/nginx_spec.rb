require 'spec_helper'

describe package('nginx') do
  it { should be_installed }
end

describe service('nginx') do
  it { should be_enabled   }
  it { should be_running   }
end

describe port(80) do
  it { should be_listening }
end

describe file('/etc/nginx/conf.d/rails.conf') do
  it { should be_file }
  it { should contain "server_name app001.gussan.pb" }
  it { should contain "upstream unicorn-unix-domain-socket" }
  it { should contain "server unix:/var/run/unicorn/unicorn_sample_app.sock" }
  it { should contain "proxy_pass http://unicorn-unix-domain-socket" }
end
