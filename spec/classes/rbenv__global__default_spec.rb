require 'spec_helper'

describe 'rbenv::global::default' do
  let(:file_path) { '/usr/lib/rbenv/version' }

  context 'Default to system' do
    it {
      should contain_file(file_path).with(
        :content => "system\n",
        :require => 'Class[Rbenv]'
      )
    }
  end
end
