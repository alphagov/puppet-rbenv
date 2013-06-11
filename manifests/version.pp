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
#   installed with the specified version of ruby
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
  $bundler_version = undef,
) {
  include rbenv::params

  $version = $title
  $package_name = "rbenv-ruby-${version}"

  package { $package_name:
    notify  => Exec["bundler for ${version}"],
    require => Class['rbenv'],
  }

  $env_vars = [
    "RBENV_ROOT=${rbenv::params::rbenv_root}",
    "RBENV_VERSION=${version}",
  ]
  $env_string = inline_template('<%= env_vars.join(" ") -%>')
  $cmd_unless = "${env_string} rbenv exec gem list | grep -Pqs '^bundler\s'"
  $cmd_install = $bundler_version ? {
    undef   => 'rbenv exec gem install bundler',
    default => "rbenv exec gem install bundler -v ${bundler_version}"
  }

  exec { "bundler for ${version}":
    command     => $cmd_install,
    unless      => $cmd_unless,
    environment => $env_vars,
    provider    => 'shell',
    notify      => Rbenv::Rehash[$version],
  }

  rbenv::rehash { $version: }
}
