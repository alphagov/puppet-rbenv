require 'spec_helper'

describe 'rbenv::version' do
  context 'Version 1.2.3-p456' do
    let(:title) { '1.2.3-p456' }
    let(:exec_title) { 'bundler for 1.2.3-p456' }

    context 'ruby version' do
      it {
        should contain_package('rbenv-ruby-1.2.3-p456').with(
          :require => 'Class[Rbenv]'
        )
      }
    end

    context 'rehash' do
      it { should contain_rbenv__rehash('1.2.3-p456') }
      it { should contain_exec(exec_title).with_notify('Rbenv::Rehash[1.2.3-p456]') }
    end

    context 'bunder' do
      it 'should prefix commands with rbenv exec' do
        should contain_exec(exec_title).with(
          :command     => /\/usr\/bin\/rbenv exec gem /,
          :unless      => /\/usr\/bin\/rbenv exec gem /
        )
      end

      it 'should set env vars for rbenv' do
        should contain_exec(exec_title).with(
          :unless      => /^RBENV_ROOT=\/usr\/lib\/rbenv RBENV_VERSION=1.2.3-p456 /,
          :environment => [
            'RBENV_ROOT=/usr/lib/rbenv',
            'RBENV_VERSION=1.2.3-p456',
          ],
          :provider    => 'shell'
        )
      end

      context 'bundler_version not set (default)' do
        it {
          should contain_exec(exec_title).with(
            :command => /gem install bundler$/
          )
        }
      end

      context 'bundler_version 8.9.0' do
        let(:params) {{
          :bundler_version => '8.9.0'
        }}

        it {
          should contain_exec(exec_title).with(
            :command => /gem install bundler -v 8.9.0$/
          )
        }
      end
    end
  end
end
