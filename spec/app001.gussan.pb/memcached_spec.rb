require 'spec_helper'

describe package('memcached') do
  it { should be_installed}
end

describe port(11211) do
  it { should be_listening }
end
