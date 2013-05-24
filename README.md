# puppet-rbenv

Manage a single system installation of rbenv and Rubies.

## Reinvention?

This differs from existing `puppet-rbenv` modules in that it uses system
packages for *everything*.  It will never call `git clone` or `rbenv
install` (normally provided by [ruby-build](https://github.com/sstephenson/ruby-build)).

This ensures that every install is consistent on every server. This is
particularly important for Ruby, which will link to whatever libraries and
headers are available on the system which it is compiled.

Examples of these packages can be seen at:

- https://github.com/alphagov/packager
- https://launchpad.net/~gds/+archive/govuk/+packages?field.name_filter=rbenv
