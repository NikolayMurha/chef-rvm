name 'chef_rvm'
maintainer 'R&R Innovation LLC'
maintainer_email 'work at murga.kiev.ua'
license 'Apache v2.0'
description 'Installs/Configures rvm'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
# source_url 'https://github.com/MurgaNikolay/chef-rvm'
# issues_url 'https://github.com/MurgaNikolay/chef-rvm/issues'
version '1.1.0'

recipe 'chef_rvm', 'Installs all'
recipe 'chef_rvm::rvm', 'Installs the rvm for users'
recipe 'chef_rvm::rubies', 'Installs rubies'
recipe 'chef_rvm::gems', 'Creates gemsets and install gems'
recipe 'chef_rvm::packages', 'General recipe. Installs dependencies for other recipes.'
recipe 'chef_rvm::wrappers', 'Create wrappers'
recipe 'chef_rvm::aliases', 'Create aliases'

supports 'ubuntu'
supports 'debian'

depends 'sudo'
depends 'apt'
depends 'build-essential'
depends 'chef_gem'
depends 'gpg'
depends 'curl'

# if using jruby, java is required on system
recommends 'java' # For jruby
recommends 'maven' # For jruby
recommends 'nodejs' # for opal
recommends 'mono' # for ironruby

# for installing on OSX, this is required for installation and compilation
suggests 'homebrew'
