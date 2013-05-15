# == Class: rbenv::version
#
# Install a version of Ruby under rbenv from a system package. Bundler will
# be installed therein.
#
# The title of the resource is used as the version.
#
# === Examples
#
# rbenv { ['1.8.7-p1', '1.9.3-p2']: }
#
define rbenv::version() {
  $version = $title
  $package_name = "rbenv-ruby-${version}"

  package { $package_name:
    notify  => Exec["bundler for ${version}"],
    require => Class['rbenv'],
  }

  exec { "bundler for ${version}":
    command     => 'rbenv exec gem install bundler',
    unless      => "RBENV_VERSION=${version} rbenv exec gem list | grep -Pqs '^bundler\s'",
    environment => "RBENV_VERSION=${version}",
    provider    => 'shell',
    notify      => Rbenv::Rehash[$version],
  }

  rbenv::rehash { $version: }
}
