require 'spec_helper'

describe package('memcached') do
  it { should be_installed}
end

describe port(11211) do
  it { should be_listening }
end

describe file('/var/run/memcached/memcached.pid') do
  it { should be_file }
end
