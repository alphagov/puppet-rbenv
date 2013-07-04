require 'spec_helper'

describe 'rbenv::global' do
  let(:facts) {{
    :osfamily => 'Debian',
  }}
  let(:file_path) { '/usr/lib/rbenv/version' }

  context 'when version is default, system' do
    it {
      should contain_file(file_path).with(
        :content => "system\n",
        :require => 'Class[Rbenv]'
      )
    }
  end

  context 'when version is 1.2.3' do
    let(:params) {{
      :version => '1.2.3',
    }}

    it {
      should contain_file(file_path).with(
        :content => "1.2.3\n",
        :require => ['Class[Rbenv]', 'Rbenv::Version[1.2.3]']
      )
    }
  end
end
