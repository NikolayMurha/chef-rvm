name 'ruby_rvm'
maintainer 'R&R Innovation LLC'
maintainer_email 'work at murga.kiev.ua'
license 'All rights reserved'
description 'Installs/Configures rvm'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version '0.4.1'

recipe 'ruby_rvm',  'Installs all'
recipe 'ruby_rvm::rvm',  'Installs the rvm for users'
recipe 'ruby_rvm::rubies', 'Installs rubies'
recipe 'ruby_rvm::gems',   'Creates gemsets and install gems'
recipe 'ruby_rvm::packages', 'General recipe. Installs dependencies for other recipes.'
recipe 'ruby_rvm::wrappers', 'Create wrappers'

depends 'sudo'
depends 'apt'
depends 'bsw_gpg'
depends 'chef_gem'

# if using jruby, java is required on system
recommends 'java'

# for installing on OSX, this is required for installation and compilation
suggests 'homebrew'
