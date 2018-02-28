def rvmrc_properties
  node['chef_rvm']['rvmrc'].merge(rvmrc || {})
end

default_action :install

property :user, String, name_property: true
property :rubies, [Hash, Array, String], default: {}
property :rvmrc, [Hash, NilClass], default: nil
property :s3_bucket, String, default: ''
property :s3_folder, String, default: ''
property :s3_region, String, default: ''
property :rvm_binary, String, default: ''
property :rvm_checksum, String, default: ''
property :ruby_binary, String, default: ''

action :install do
  unless rvm.rvm?
    if new_resource.rvm_binary.empty?
      rvm.rvm_install('')
    else
      aws_s3_file "#{Chef::Config[:file_cache_path]}/#{new_resource.rvm_binary}" do
        bucket new_resource.s3_bucket
        remote_path "#{new_resource.s3_folder}/#{new_resource.rvm_binary}"
        region new_resource.s3_region
        action :nothing
      end.run_action(:create)

      ark 'rvm' do
        url "file://#{Chef::Config[:file_cache_path]}/#{new_resource.rvm_binary}"
        path Chef::Config[:file_cache_path]
        checksum new_resource.rvm_checksum
        owner new_resource.user
        group new_resource.user
        action :nothing
      end.run_action(:put)
      rvm.rvm_install("#{Chef::Config[:file_cache_path]}/rvm")
    end
    updated_by_last_action(true)
  end
  rubies = new_resource.rubies
  if rubies
    unless new_resource.ruby_binary.empty?
      aws_s3_file "#{Chef::Config[:file_cache_path]}/#{new_resource.ruby_binary}" do
        bucket new_resource.s3_bucket
        remote_path "#{new_resource.s3_folder}/#{new_resource.ruby_binary}"
        region new_resource.s3_region
        action :nothing
      end.run_action(:create)
    end
    rubies = Array(rubies) if rubies.is_a?(String)
    rubies.each do |ruby_string, options|
      options ||= {}
      chef_rvm_ruby "#{new_resource.user}:#{ruby_string}" do
        user new_resource.user
        version ruby_string
        patch options['patch']
        default options['default']
        binary "#{Chef::Config[:file_cache_path]}/#{new_resource.ruby_binary}"
      end
    end
  end
  create_or_update_rvmvc
end

action :upgrade do
  if rvm.rvm?
    Chef::Log.info "Upgrade RVM for user #{new_resource.user}"
    rvm.rvm_get(:stable)
    updated_by_last_action(true)
  else
    Chef::Log.info "Rvm is not installed for #{new_resource.user}"
  end
end

action :implode do
  if rvm.rvm?
    Chef::Log.info "Implode RVM for user #{new_resource.user}"
    rvm.rvm_implode
    updated_by_last_action(true)
  else
    Chef::Log.info "Rvm is not installed for #{new_resource.user}"
  end
end

action_class.class_eval do
  include ChefRvmCookbook::RvmResourceHelper

  def create_or_update_rvmvc
    if rvm.system?
      rvmrc_file = '/etc/rvmrc'
      rvm_path = '/usr/local/rvm/'
    else
      rvmrc_file = "#{rvm.user_home}/.rvmrc"
      rvm_path = "#{rvm.user_home}/.rvm"
    end

    template rvmrc_file do
      cookbook 'chef_rvm'
      source 'rvmrc.erb'
      owner new_resource.user
      mode '0644'
      variables(
        system_install: rvm.system?,
        rvmrc: rvmrc_properties.merge(
          rvm_path: rvm_path
        )
      )
      action :create
    end
  end
end
