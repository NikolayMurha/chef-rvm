class Chef
  class Cookbook
    class RVM
      class Environment
        def self.new(*args)
          klass = Class.new(::RVM::Environment) do
            attr_reader :user, :source_environment

            def initialize(user = nil, environment_name = 'default', options = {})
              @source_environment = options.delete(:source_environment)
              @source_environment = true if @source_environment.nil?
              @user = user
              # explicitly set rvm_path if user is set
              if @user.nil?
                config['rvm_path'] = @@root_rvm_path
              else
                config['rvm_path'] = File.join(Etc.getpwnam(@user).dir, '.rvm')
              end

              merge_config! options
              @environment_name = environment_name
              @shell_wrapper = ::Chef::Cookbook::RVM::UserShellWrapper.new(@user)
              @shell_wrapper.setup do |_|
                if source_environment
                  source_rvm_environment
                  use_rvm_environment
                end
              end
            end

            def self.root_rvm_path=(path)
              @@root_rvm_path = path
            end
          end
          klass.new(*args)
        end
      end
    end
  end
end
