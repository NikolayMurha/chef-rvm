include Chef::DSL::IncludeRecipe

action :install do
  include_recipe 'sudo'
  install = ruby_block "Install Ruby for user" do
    block do
      Chef::Log.info "Install ruby #{new_resource.version} for user #{new_resource.user}"
      env = Chef::Cookbook::RVM::Environment.new(new_resource.user)
      env.install(new_resource.version)
    end
    action :nothing
    notifies :remove, "sudo[#{new_resource.user}]"
  end

  rvm new_resource.user do
    action :install
    notifies :run, install
  end
end

action :upgrade do

end

action :uninstall do

end
