# == Class: rbenv::global
#
# Set a Ruby version as the global. This is intended to be called by the
# parent `Rbenv` class. It should not be called directly.
#
# === Parameters:
#
# [*version*]
#   Version to use. A matching `Rbenv::Version[]` resource must exist,
#   unless `system` is specified.
#   Default: system
#
class rbenv::global(
  $version = 'system'
) {
  include rbenv::params

  $require_real = $version ? {
    'system' => Class['rbenv'],
    default  => [
      Class['rbenv'],
      Rbenv::Version[$version],
    ],
  }

  file { $rbenv::params::global_version:
    ensure  => present,
    content => "${version}\n",
    require => $require_real,
  }
}
