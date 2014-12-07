include RvmCookbook::Helpers

actions :install, :remove, :uninstall
default_action :install

attribute :user, kind_of: [String], default: 'root'
attribute :version, kind_of: [Array, String], :required => true
attribute :patch, kind_of: [String, NilClass], default: nil
attribute :default, kind_of: [TrueClass, FalseClass, NilClass], default: nil
