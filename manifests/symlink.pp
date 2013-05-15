# == Define: rbenv::symlink
#
# Create a symlink from one installed version of Ruby to another. Can be
# used to abstract patch numbers from Ruby semvers.
#
# The title of the resource is used as the aliased version.
#
# === Parameters
#
# [*to_version*]
#   Real version to link to. Depends on a matching `Rbenv::Version[]`
#   resource.
#
# === Examples
#
# rbenv::version { '1.9.3-p123': }
# rbenv::symlink { '1.9.3':
#   to_version => '1.9.3-p123',
# } 
#
define rbenv::symlink(
  $to_version
) {
  $versions_path = '/usr/lib/rbenv/versions'

  file { "${versions_path}/${title}":
    ensure  => link,
    target  => $to_version,
    require => Rbenv::Version[$to_version],
  }
}
