include Chef::Cookbook::RVM::Helpers

actions :install, :uninstall, :update
default_action :install

attribute :gem, kind_of: [String]
attribute :user, kind_of: [String], default: 'root'
attribute :ruby_string, kind_of: [String], required: true

def version
  ruby_string
end
