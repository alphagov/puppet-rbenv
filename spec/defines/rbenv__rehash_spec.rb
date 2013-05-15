require 'spec_helper'

describe 'rbenv::rehash' do
  context 'Version 1.2.3-p456' do
    let(:title) { '1.2.3-p456' }

    it { 
      should contain_exec('rbenv rehash for 1.2.3-p456').with(
        :environment => 'RBENV_VERSION=1.2.3-p456',
        :refreshonly => true
      )
    }
  end
end
