include RvmCookbook::Helpers

actions :create, :delete, :update, :pristine, :prune
default_action :create
attribute :user, kind_of: [String], default: 'root'
attribute :ruby_string, kind_of: [String], name_attribute: true, :required => true

def version
  ruby_string
end
