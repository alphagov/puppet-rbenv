# == Class: rbenv::global
#
# Set a Ruby version as the global. Overrides the default which is
# provided by `Rbenv::Global::Default[]`.
#
# === Parameters:
#
# [*version*]
#   Version to use. A matching `Rbenv::Version[]` resource must exist. Must
#   not be `system`.
#
# === Examples
#
# Use a specific version installed by Puppet:
#
# rbenv::version { '1.9.3-p123': }
# class { 'rbenv::global':
#   version => '1.9.3-p123',
# }
#
class rbenv::global(
  $version = 'system'
) inherits rbenv::global::default {
  if ($version == 'system') {
    fail("${title}: Use rbenv::global::default to set 'system'")
  }

  include rbenv::params

  File[$rbenv::params::global_version] {
    content => "${version}\n",
    require +> Rbenv::Version[$version],
  }
}
