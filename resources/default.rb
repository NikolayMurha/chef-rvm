
actions :install, :uninstall, :upgrade
default_action :install
attribute :user, kind_of: [String, NilClass], name_attribute: true, default: 'root'
attribute :rubies, kind_of: [String, Array], :default => []
attribute :rvmrc, kind_of: [Hash, NilClass], :default => nil
# attribute :rubygems, kind_of: [String, NilClass], :default => nil

def system?
  name == 'root'
end

def user_home
  Etc.getpwnam(self.user).dir
end

def get_rvmrc
  node['rvm']['rvmrc'].merge(self.rvmrc || {})
end
