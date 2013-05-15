require 'rake'
task :default => [:lint, :spec]

require 'puppet-lint/tasks/puppet-lint'
PuppetLint.configuration.ignore_paths = ["vendor/**/*.pp"]

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec) do |t|
  t.pattern = 'spec/*/*_spec.rb'
end
