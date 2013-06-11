require 'spec_helper'

describe 'rbenv::global' do
  let(:file_path) { '/usr/lib/rbenv/version' }

  context 'when version is set to system' do
    let(:params) {{
      :version => 'system',
    }}

    it do
      expect {
        should contain_file(file_path)
      }.to raise_error(Puppet::Error, /^rbenv::global: Use rbenv::global::default/)
    end
  end

  context 'when rbenv::global::default is explicitly included' do
    let(:pre_condition) { "class { 'rbenv::global::default': }" }
    let(:params) {{
      :version => '1.2.3',
    }}

    it { should include_class('rbenv::global::default') }

    it {
      should contain_file(file_path).with(
        :content => "1.2.3\n",
        :require => ['Class[Rbenv]', 'Rbenv::Version[1.2.3]']
      )
    }
  end

  context 'when rbenv::global::default is not explcitily included' do
    let(:params) {{
      :version => '4.5.6',
    }}

    it {
      should contain_file(file_path).with(
        :content => "4.5.6\n",
        :require => ['Class[Rbenv]', 'Rbenv::Version[4.5.6]']
      )
    }
  end
end
