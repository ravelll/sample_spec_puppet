require 'spec_helper'

describe service('unicorn') do
  it { should be_running }
end

describe file('/var/run/unicorn/unicorn.sock') do
  it { should be_socket }
end
