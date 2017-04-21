class Chef
  class Resource
    class ChefRvmScript < Chef::Resource::Script
      include ::ChefRvmCookbook::ExecuteResourceMixin

      def initialize(name, run_context = nil)
        if Gem::Version.new(Chef::VERSION) < Gem::Version.new(::ChefRvmCookbook::MIN_SUPPORTED_VERSION)
          raise "Resource 'chef_rvm_script' is not supported by the Chef Client #{Chef::VERSION}. Please upgrade Chef Client to #{::ChefRvmCookbook::MIN_SUPPORTED_VERSION} or higher."
        end
        super
        provider Chef::Provider::ChefRvmScript
        @resource_name = :chef_rvm_script
        @ruby_string = 'system'
        @guard_interpreter = :chef_rvm_script
      end

      set_guard_inherited_attributes(
        :cwd,
        :environment,
        :group,
        :user,
        :umask,
        :ruby_string,
        :interpreter
      )
    end
  end
end
