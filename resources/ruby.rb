include Chef::Cookbook::RVM::Helpers

actions :install, :remove, :uninstall
attribute :user, kind_of: [ String ], name_attribute: true, default: 'root'
attribute :version, kind_of: [ Array, String ], :required => true
attribute :patch, kind_of: [ String, NilClass ], default: nil
attribute :default, kind_of: [ TrueClass, FalseClass, NilClass ], default: nil
