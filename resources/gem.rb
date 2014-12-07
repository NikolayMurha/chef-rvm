include RvmCookbook::Helpers

actions :install, :uninstall, :update
default_action :install

attribute :gem, kind_of: [String]
attribute :version, kind_of: [String, NilClass], default: nil
attribute :user, kind_of: [String], default: 'root'
attribute :ruby_string, kind_of: [String], required: true
