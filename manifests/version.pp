# == Class: rbenv::version
#
# Install a version of Ruby under rbenv from a system package. Bundler will
# be installed therein.
#
# The title of the resource is used as the version.
#
# NB: Exec[] resources do not assume that rbenv has been initialised from
# `profile.d` because Puppet may be running from a non-login and
# non-interactive shell (e.g. cron). They explicitly pass `RBENV_ROOT` and
# reference `rbenv exec` (rather than the shim) for this reason.
#
# === Parameters
# [*bundler_version*]
#   Optional parameter that allows to specify the version of bundler to be
#   installed with the specified version of ruby.
#   Default: >= 0
#
# === Examples
#
# rbenv { ['1.8.7-p1', '1.9.3-p2']: }
#
# rbenv { '1.9.3-p327':
#   bundler_version => '1.1.4',
# }
#
define rbenv::version (
  $bundler_version = '>= 0'
) {
  include rbenv::params

  $version = $title
  $package_name = "rbenv-ruby-${version}"

  package { $package_name:
    notify  => Exec["install bundler for ${version}"],
    require => Class['rbenv'],
  }

  $env_vars   = [
    "RBENV_ROOT=${rbenv::params::rbenv_root}",
    "RBENV_VERSION=${version}",
  ]

  $cmd_gem     = "${rbenv::params::rbenv_binary} exec gem"
  $cmd_unless  = "${cmd_gem} list | grep -Pqs '^bundler\s'"
  $cmd_install = "${cmd_gem} install bundler -v '${bundler_version}'"

  exec { "install bundler for ${version}":
    command     => $cmd_install,
    unless      => $cmd_unless,
    environment => $env_vars,
    notify      => Rbenv::Rehash[$version],
  }

  rbenv::rehash { $version: }
}
