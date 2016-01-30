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

  it 'should make rbenv available' do
    rbenv_command = shell("rbenv")
    expect(rbenv_command.exit_code).to eq 0
  end
end
