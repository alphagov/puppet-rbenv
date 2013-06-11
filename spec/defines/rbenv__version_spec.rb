require 'spec_helper'

describe 'rbenv::version' do
  context 'Version 1.2.3-p456' do
    let(:title) { '1.2.3-p456' }

    it {
      should contain_package('rbenv-ruby-1.2.3-p456').with(
        :require => 'Class[Rbenv]'
      )
    }

    context 'should install bundler without specifying version if bundler_version not provided' do
      it {
        should contain_exec('bundler for 1.2.3-p456').with(
          :command     => /^\/usr\/bin\/rbenv exec gem install bundler$/,
          :unless      => /^RBENV_ROOT=\/usr\/lib\/rbenv RBENV_VERSION=1.2.3-p456 \/usr\/bin\/rbenv exec/,
          :environment => [
            'RBENV_ROOT=/usr/lib/rbenv',
            'RBENV_VERSION=1.2.3-p456',
          ],
          :provider => 'shell',
          :notify => 'Rbenv::Rehash[1.2.3-p456]'
        )
      }
    end

    context 'should install bundler with specified version' do
      let(:params) { {
        :bundler_version => '8.9.0'
      } }
      it {
        should contain_exec('bundler for 1.2.3-p456').with(
          :command => /^\/usr\/bin\/rbenv exec gem install bundler -v 8.9.0$/
        )
      }
    end

    it { should contain_rbenv__rehash('1.2.3-p456') }
  end
end
