require 'spec_helper'

describe package('mysql') do
  it { should be_installed }
end

describe service('mysqld') do
  it { should be_enabled   }
  it { should be_running   }
end

describe host('db001.gussan.pb') do
  it { should be_reachable }
  it { should be_reachable.with( :port => 3306, :proto => 'tcp' ) }
end
