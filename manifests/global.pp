# == Class: rbenv::global
#
# Set a Ruby version as the global default.
#
# TODO: Always manage this file. Use inheritance?
#
# === Parameters:
#
# [*version*]
#   Version to use. A matching `Rbenv::Version[]` resource must exist.
#   Default: system
#
# === Examples
#
# Use the default system binary:
#
# include rbenv::global
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
){
  $real_require = $version ? {
    'system' => Class['rbenv'],
    default  => Rbenv::Version[$version],
  }

  file { '/usr/lib/rbenv/version':
    ensure  => present,
    content => "${version}\n",
    require => $real_require,
  }
}
