
actions :install, :uninstall, :upgrade
attribute :user, kind_of: [String, NilClass], name_attribute: true, default: 'root'
attribute :rubies, kind_of: [String, Array, NilClass], :default => nil

def system?
  name == 'root'
end

def user_home
  Etc.getpwnam(new_resource.user).dir
end
