actions :install, :remove, :uninstall, :reinstall
default_action :install

attribute :user, kind_of: [String], default: 'root'
attribute :version, kind_of: [Array, String], :required => true
attribute :patch, kind_of: [String, NilClass], default: nil
attribute :default, kind_of: [TrueClass, FalseClass, NilClass], default: nil

attribute :mount, kind_of: [TrueClass, FalseClass, NilClass], default: nil
attribute :path, kind_of: [TrueClass, FalseClass, NilClass], default: nil

