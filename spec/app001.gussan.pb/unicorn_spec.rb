require 'spec_helper'

describe service('unicorn') do
  it { should be_running }
end

describe file('/var/run/unicorn/unicorn_sample_app.sock') do
  it { should be_socket }
end
