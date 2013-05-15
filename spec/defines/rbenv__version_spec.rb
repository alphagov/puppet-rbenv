require 'spec_helper'

describe 'rbenv::version' do
  context 'Version 1.2.3-p456' do
    let(:title) { '1.2.3-p456' }

    it {
      should contain_package('rbenv-ruby-1.2.3-p456').with(
        :require => 'Class[Rbenv]'
      )
    }

    it {
      should contain_exec('bundler for 1.2.3-p456').with(
        :environment => 'RBENV_VERSION=1.2.3-p456',
        :provider => 'shell',
        :notify => 'Rbenv::Rehash[1.2.3-p456]'
      )
    }

    it { should contain_rbenv__rehash('1.2.3-p456') }
  end
end
