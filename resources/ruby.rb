
default_action :install

property :user, [String], required: true
property :version, [Array, String], required: true
property :patch, [String, NilClass], default: nil
property :default, [TrueClass, FalseClass, NilClass], default: nil
property :s3_bucket, String, default: ''
property :s3_folder, String, default: ''
property :s3_region, String, default: ''
property :binary, String, default: ''
property :checksum, String, default: ''

action :install do
  if rvm.ruby?(new_resource.version)
    Chef::Log.debug "Ruby #{new_resource.version} already installed for user #{new_resource.user}"
  else
    unless new_resource.binary.empty?
      aws_s3_file "#{Chef::Config[:file_cache_path]}/#{new_resource.binary}" do
        bucket new_resource.s3_bucket
        remote_path "#{new_resource.s3_folder}/#{new_resource.binary}"
        region new_resource.s3_region
        action :nothing
      end.run_action(:create)

      ruby_block 'verify checksum' do
        block do
          Chef::Application.fatal!('file checksum does not match')
        end
        not_if { OpenSSL::Digest::SHA256.file("#{Chef::Config[:file_cache_path]}/#{new_resource.binary}").hexdigest == new_resource.checksum }
      end
    end
    requirements_install(new_resource.version)
    Chef::Log.debug "Install ruby #{new_resource.version} for user #{new_resource.user}"
    rvm.ruby_install(new_resource.version, new_resource.patch, "#{Chef::Config[:file_cache_path]}/#{new_resource.binary}")
    rvm.gemset_create(new_resource.version)
    updated_by_last_action(true)
  end
  rvm.ruby_set_default(new_resource.version) if new_resource.default
end

%i(remove uninstall reinstall).each do |action_name|
  action action_name do
    if rvm.ruby?(new_resource.version)
      Chef::Log.debug "#{action_name.to_s.capitalize} ruby #{new_resource.version} for user #{new_resource.user}"
      updated_by_last_action(true)
    else
      Chef::Log.debug "Ruby #{new_resource.version} is not installed for user #{new_resource.user}"
    end
  end
end

action_class.class_eval do
  include ChefRvmCookbook::RvmResourceHelper
  include ChefRvmCookbook::Requirements
end
