require 'rake'
task :default => [:lint]

require 'puppet-lint/tasks/puppet-lint'
PuppetLint.configuration.ignore_paths = ["vendor/**/*.pp"]
