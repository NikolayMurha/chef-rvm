
actions :install, :uninstall, :upgrade
attribute :user, kind_of: [String, NilClass], name_attribute: true, default: 'root'
attribute :rubies, kind_of: [String, Array, NilClass], :default => nil
attribute :rvmrc, kind_of: [Hash, NilClass], :default =>

def system?
  name == 'root'
end

def user_home
  Etc.getpwnam(self.user).dir
end

def get_rvmrc
  node['rvm']['rvmrc'].merge(self.rvmrc || {})
end
