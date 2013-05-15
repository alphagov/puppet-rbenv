require 'spec_helper'

describe 'rbenv' do
  it { should contain_package('rbenv') }

  it {
    should contain_file('/etc/profile.d/rbenv.sh').with(
      :mode    => '0755',
      :require => 'Package[rbenv]'
    )
  }
end
