default['rvm']['packages'] = value_for_platform(
  # rhel: { default: %w{} },
  # ubuntu: { default: %w{} },
  default: %w(bash tar curl gzip git subversion)
)

default['rvm']['rvmrc']['rvm_gem_options'] = '--no-rdoc --no-ri'
default['rvm']['rvmrc']['rvm_autoupdate_flag'] = 0

default['rvm']['users'] = {}
