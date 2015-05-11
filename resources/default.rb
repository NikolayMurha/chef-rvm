actions :install, :implode, :upgrade
default_action :install
attribute :user, kind_of: [String, NilClass], name_attribute: true, default: 'root'
attribute :rubies, kind_of: [String, Array], :default => []
attribute :rvmrc, kind_of: [Hash, NilClass], :default => nil
# attribute :rubygems, kind_of: [String, NilClass], :default => nil

def rvmrc_properties
  node['chef_rvm']['rvmrc'].merge(rvmrc || {})
end
