# == Define: rbenv::rehash
#
# Run `rbenv rehash` for a specific version of Ruby. Typically refreshed by
# `Rbenv::Version[]` after installation.
#
# The title of the resource is used as the version.
#
# TODO: Does this need to be version specific?
#
define rbenv::rehash() {
  $version = $title

  exec { "rbenv rehash for ${version}":
    command     => 'rbenv rehash',
    environment => "RBENV_VERSION=${version}",
    refreshonly => true,
  }
}
