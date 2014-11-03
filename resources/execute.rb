include Chef::Cookbook::RVM::Helpers
actions :create, :delete, :update, :pristine, :prune
default_action :create
attribute :command, kind_of: [String], name_attribute: true, :required => true
attribute :user, kind_of: [String], default: 'root'
attribute :path, kind_of: [String], :required => false
attribute :ruby_string, kind_of: [String,Array], :required => false
