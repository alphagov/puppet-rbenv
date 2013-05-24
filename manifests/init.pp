# == Class: rbenv
#
# Install rbenv from a system package and create an `/etc/profile.d` to do
# the following for all new shell sessions:
#
# - Set `RBENT_ROOT` to a common system path.
# - Run `rvenv init`.
#
class rbenv {
  include rbenv::params

  package { 'rbenv':
    ensure => present,
  }

  file { '/etc/profile.d/rbenv.sh':
    ensure  => present,
    mode    => '0755',
    content => template('rbenv/etc/profile.d/rbenv.sh.erb'),
    require => Package['rbenv'],
  }
}
