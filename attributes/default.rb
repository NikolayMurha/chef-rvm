default['rvm']['packages'] = value_for_platform(
  # rhel: { default: %w{} },
  # ubuntu: { default: %w{} },
  default: %w(bash tar curl gzip git subversion)
)

default['rvm']['rvmrc']['rvm_gem_options'] = '--no-rdoc --no-ri'
default['rvm']['rvmrc']['rvm_autoupdate_flag'] = 0

default['rvm']['users'] = {}
default['rvm']['rubies'] = {}
default['rvm']['gems'] = {}
default['rvm']['wrappers'] = {}
# default['rvm']['rubies'] = {
#   'ubuntu' => [{ version: '1.9.3', default: true }, '2.0', '2.1']
# }
# default['rvm']['gems'] = {
#   'ubuntu' =>
#     {
#       '1.9.3@test' => %w(eye rails),
#       '1.9.3@test2' => %w(eye rails)
#     }
# }

# RVM
# default['rvm']['users'] = %w(ubuntu deploy)
# default['rvm']['users'] = {
#   ubuntu: ['1.9.3', '2.0.0']
#   deploy: '1.9.3'
# }

# default['rvm']['users'] = {
#   ubuntu: [{version: '1.9.3', default: true}, '2.0.0']
#   deploy: '1.9.3'
# }

# GEMS
# default['rvm']['gems'] = {
#   ubuntu: {
#     :'1.9.3@gemset' => %w(eye rails)
#   }
# }
#
# default['rvm']['gems'] = {
#   ubuntu: {
#     :'1.9.3@gemset' => {
#       eye: '0.6',
#       rails: '4.1.1'
#     }
#   }
# }

# Rubies
# default['rvm']['rubies'] = {
#   ubuntu: '1.9.3',
#   deploy: '2.0'
# }
#
# default['rvm']['rubies'] = {
#   ubuntu: %w(1.9.3 2.0 2.1),
#   deploy: '2.0'
# }
#
# default['rvm']['rubies'] = {
#   ubuntu: [{version: '1.9.3', default: true}, '2.0', '2.1'],
#   deploy: '2.0'     Rubies
# default['rvm']['rubies'] = {
#   ubuntu: '1.9.3',
#   deploy: '2.0'
# }
#
# default['rvm']['rubies'] = {
#   ubuntu: %w(1.9.3 2.0 2.1),
#   deploy: '2.0'
# }
#
# default['rvm']['rubies'] = {
#   ubuntu: [{version: '1.9.3', default: true}, '2.0', '2.1'],
#   deploy: '2.0'
# }
# }

# Wrappers
# default['rvm']['wrappers'] = {
#   ubuntu: [
#     {
#       :'1.9.3@gemset' => {
#         bootup: 'god'
#       }
#     }
#   ]
# }
# default['rvm']['wrappers'] = {
#   ubuntu: [
#     {
#       :'1.9.3@gemset' => {
#         bootup: %w(god eye)
#       }
#     }
#   ]
# }
