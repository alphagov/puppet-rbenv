require 'spec_helper_acceptance'

describe 'rbenv class' do
  let(:manifest) {
    <<-EOS
      class { 'rbenv': }
    EOS
  }

  it 'should run without errors' do
    result = apply_manifest(manifest)
    expect(@result.exit_code).to eq 2
  end
end
