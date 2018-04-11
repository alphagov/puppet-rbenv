require 'spec_helper'

describe 'rbenv::version' do
  let(:facts) {{
    :osfamily => 'Debian',
  }}

  context 'Version 1.2.3-p456' do
    let(:title) { '1.2.3-p456' }
    let(:exec_title) { 'install bundler for 1.2.3-p456' }
    let(:rbenv_etc) { '/usr/lib/rbenv/versions/1.2.3-p456/etc' }
    let(:cmd_prefix) { /^\/usr\/bin\/env -uRUBYOPT -uBUNDLE_GEMFILE -uGEM_HOME -uGEM_PATH \/usr\/bin\/rbenv exec gem/ }

    context 'ruby version' do
      it {
        should contain_package('rbenv-ruby-1.2.3-p456').with(
          :ensure  => "latest",
          :notify  => "File[#{rbenv_etc}]",
          :require => 'Class[Rbenv]'
        )
      }

      it {
        should contain_file("#{rbenv_etc}/gemrc").with(
          :ensure => "absent",
          :force => true
        )
      }

      context 'skipping the installation of gem documentation' do
        let(:params) {{
          :install_gem_docs => false,
        }}

        it {
          should contain_file(rbenv_etc).with(
            :ensure => "directory",
          )

          should contain_file("#{rbenv_etc}/gemrc").with(
            :ensure => "present",
            :content => "gem: --no-document --no-rdoc --no-ri\n"
          )
        }
      end
    end

    context 'rehash' do
      it { should contain_rbenv__rehash('1.2.3-p456') }
      it { should contain_exec(exec_title).with_notify('Rbenv::Rehash[1.2.3-p456]') }
    end

    context 'bundler' do
      it 'should set env vars for rbenv' do
        should contain_exec(exec_title).with(
          :environment => [
            'RBENV_ROOT=/usr/lib/rbenv',
            'RBENV_VERSION=1.2.3-p456',
          ]
        )
      end

      context 'bundler_version not set (default)' do
        it {
          should contain_exec(exec_title).with(
            :command => /#{cmd_prefix} install bundler -v '>= 0'$/,
            :unless  => /#{cmd_prefix} query -i -n bundler -v '>= 0'$/
          )
        }
      end

      context 'bundler_version 8.9.0' do
        let(:params) {{
          :bundler_version => '8.9.0'
        }}

        it {
          should contain_exec(exec_title).with(
            :command => /#{cmd_prefix} install bundler -v '8.9.0'$/,
            :unless  => /#{cmd_prefix} query -i -n bundler -v '8.9.0'$/
          )
        }
      end
    end

    context 'removing a version' do
      let(:params) {{
        :ensure => 'absent',
      }}

      it { should contain_package('rbenv-ruby-1.2.3-p456').with_ensure('purged') }

      it {
        should contain_file('/usr/lib/rbenv/versions/1.2.3-p456').with(
          :ensure => "absent",
          :force => true
        )
      }

      it { should_not contain_exec(exec_title) }

      it { should_not contain_rbenv__rehash('1.2.3-p456') }
    end

    context 'invalid ensure parameter' do
      let(:params) {{
        :ensure => 'wibble',
      }}

      it { is_expected.to compile.and_raise_error(/Invalid value 'wibble' for ensure/) }
    end
  end
end
