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
# === Examples
#
# rbenv { ['1.8.7-p1', '1.9.3-p2']: }
#
define rbenv::version() {
  include rbenv::params

  $version = $title
  $package_name = "rbenv-ruby-${version}"

  $env_vars = [
    "RBENV_ROOT=${rbenv::params::rbenv_root}",
    "RBENV_VERSION=${version}",
  ]
  $env_string = inline_template('<%= env_vars.join(" ") -%>')

  package { $package_name:
    notify  => Exec["bundler for ${version}"],
    require => Class['rbenv'],
  }

  exec { "bundler for ${version}":
    command     => 'rbenv exec gem install bundler',
    unless      => "${env_string} rbenv exec gem list | grep -Pqs '^bundler\s'",
    environment => $env_vars,
    provider    => 'shell',
    notify      => Rbenv::Rehash[$version],
  }

  rbenv::rehash { $version: }
}
