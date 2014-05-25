include Chef::Cookbook::RVM::Helpers

actions :create, :delete, :update, :pristine, :prune
default_action :create
attribute :user, kind_of: [String], default: 'root'
attribute :ruby_string, kind_of: [String], name_attribute: true, :required => true

# def name(arg = nil)
#   if arg.nil?
#     "rvm:gemset:#{user}:#{gemset}"
#   else
#     set_or_return(:full_name, arg, :kind_of => String)
#   end
# end

def version
  ruby_string
end
