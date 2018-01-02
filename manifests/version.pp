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
# [*ensure*]
#   Default: present
#
#   If set to absent, this will remove the specified version from the system
#
# [*bundler_version*]
#   Optional parameter to specify the version of Bundler to be installed for
#   the given version of Ruby. Accepts pessimistic versioning (~> x.y).
#
#   NB: It will NOT attempt to remove any currently installed versions of
#   Bundler. This means that upgrades will work as expected, but downgrades
#   will not. The greatest installed version always takes precendence.
#
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
  $ensure = 'present',
  $bundler_version = '>= 0'
) {
  include rbenv::params

  $version = $title
  $package_name = "rbenv-ruby-${version}"

  if $ensure == 'present' {
    package { $package_name:
      ensure  => latest,
      notify  => Exec["install bundler for ${version}"],
      require => Class['rbenv'],
    }

    $env_vars = [
      "RBENV_ROOT=${rbenv::params::rbenv_root}",
      "RBENV_VERSION=${version}",
    ]

    $unset_vars  = '/usr/bin/env -uRUBYOPT -uBUNDLE_GEMFILE -uGEM_HOME -uGEM_PATH'
    $cmd_gem     = "${unset_vars} ${rbenv::params::rbenv_binary} exec gem"
    $cmd_install = "${cmd_gem} install bundler -v '${bundler_version}'"
    $cmd_unless  = "${cmd_gem} query -i -n bundler -v '${bundler_version}'"

    exec { "install bundler for ${version}":
      command     => $cmd_install,
      unless      => $cmd_unless,
      environment => $env_vars,
      notify      => Rbenv::Rehash[$version],
    }

    rbenv::rehash { $version: }

    # Save time and inodes by not installing gem documentation by default.
    file { "${rbenv::params::rbenv_root}/versions/${version}/etc":
      ensure => directory,
    }
    file { "${rbenv::params::rbenv_root}/versions/${version}/etc/gemrc":
      ensure  => present,
      content => "gem: --no-document --no-rdoc --no-ri\n",
    }

  } elsif $ensure == 'absent' {

    package { $package_name:
      ensure => purged,
    }

    # Cleanup bundler and any other gems (installed by the above exec)
    file { "${rbenv::params::rbenv_root}/versions/${version}":
      ensure  => absent,
      force   => true,
      require => Package[$package_name],
    }

  } else {
    fail("Invalid value '${ensure}' for ensure. Must be 'present' or 'absent'")
  }
}
