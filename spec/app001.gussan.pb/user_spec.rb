require 'spec_helper'

describe user('gussan') do
  it { should exist }
  it { should have_home_directory '/home/gussan' }
  it { should have_uid 1000 }
  it { should belong_to_group 'app_user' }
  it { should belong_to_group 'rbenv' }
end

describe group('app_user') do
  it { should have_gid 1000 }
end
require 'spec_helper'

describe user('gussan') do
  it { should exist }
  it { should have_home_directory '/home/gussan' }
  it { should have_uid 1000 }
  it { should belong_to_group 'app_user' }
  it { should belong_to_group 'rbenv' }
end

describe group('app_user') do
  it { should have_gid 1000 }
end
