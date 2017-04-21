require 'chef/resource'
class Chef
  class Resource
    class ChefRvmExecute < Chef::Resource::Execute
      include ::ChefRvmCookbook::ExecuteResourceMixin

      def initialize(name, run_context = nil)
        if Gem::Version.new(Chef::VERSION) < Gem::Version.new(::ChefRvmCookbook::MIN_SUPPORTED_VERSION)
          raise "Resource 'chef_rvm_execute' is not supported by the Chef Client #{Chef::VERSION}. Please upgrade Chef Client to #{::ChefRvmCookbook::MIN_SUPPORTED_VERSION} or higher."
        end
        super
        provider Chef::Provider::ChefRvmExecute
        @resource_name = :chef_rvm_execute
        @guard_interpreter = :chef_rvm_execute
        @ruby_string = 'system'
      end

      set_guard_inherited_attributes(
        :cwd,
        :environment,
        :group,
        :user,
        :umask,
        :ruby_string
      )
    end
  end
end
