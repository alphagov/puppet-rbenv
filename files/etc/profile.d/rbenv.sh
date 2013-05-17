# rbenv work by intercepting invocations of 'ruby' etc. with a shim which basically
# dispatches to a specified version of ruby, therefore rbenv needs to be on the default path

export RBENV_ROOT="/usr/lib/rbenv"
export PATH="$RBENV_ROOT/bin:$PATH"
[ -d "$RBENV_ROOT" ] && eval "$(rbenv init -)"
