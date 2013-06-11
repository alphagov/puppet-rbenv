# == Class: rbenv::global::default
#
# Default the global version to 'system'. This should be included by the
# main `Rbenv` class. It should not be included directly.
#
# Defining the default here, in a separate class, ensures that the file is
# always managed. Even when `Rbenv::Global` is not used.
#
# It can be subsequently overridden with `Rbenv::Global`.
#
class rbenv::global::default() {
  include rbenv::params

  file { $rbenv::params::global_version:
    ensure  => present,
    content => "system\n",
    require => Class['rbenv'],
  }
}
