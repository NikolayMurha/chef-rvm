class RvmCookbook
  module EnvironmentFactory
    def self.env(user)
      # cache environment for user
      @env ||= {}
      @env[user] ||= RvmCookbook::Environment.new(user)
    end

    def env(user = nil)
      @env ||= RvmCookbook::Environment.new(user || new_resource.user)
    end
  end

  module EnvironmentMixin
    attr_reader :user

    def rvm_path
      if @user.nil?
        Environment.root_rvm_path || '/usr/local/rvm'
      else
        File.join(Etc.getpwnam(@user).dir, '.rvm')
      end
    end

    def shell_params
      return {} unless @user
      {
        user: @user,
        environment: environment
      }
    end

    def environment(env = {})
      return env unless @user
      {
        'USER' => @user,
        'HOME' => Etc.getpwnam(@user).dir,
        'rvm_path' => rvm_path
      }.merge(env)
    end
  end

  class Environment
    class << self
      attr_accessor :root_rvm_path
    end

    def self.new(*args)
      klass = Class.new(::RVM::Environment) do
        attr_reader :user, :source_environment
        include EnvironmentMixin

        def initialize(user = nil, environment_name = 'default', options = {})
          @source_environment = options.delete(:source_environment)
          @source_environment = true if @source_environment.nil?
          @user = user
          config['rvm_path'] = rvm_path
          merge_config! options
          @environment_name = environment_name
          @shell_wrapper = ::RvmCookbook::UserShellWrapper.new(@user)
          @shell_wrapper.setup do |_|
            if source_environment
              source_rvm_environment
              use_rvm_environment
            end
          end
        end
      end
      klass.new(*args)
    end
  end
end
