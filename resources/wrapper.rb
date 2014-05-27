actions :create, :update
default_action :create

attribute :prefix, :kind_of => String
attribute :ruby_string, :kind_of => String
attribute :binary, :kind_of => String
attribute :user, :kind_of => String
