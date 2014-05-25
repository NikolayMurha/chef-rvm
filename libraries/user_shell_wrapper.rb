class Chef
  class Cookbook
    class RVM
      class UserShellWrapper
        def self.new(*args)
          klass = Class.new(::RVM::Shell::SingleShotWrapper) do
            alias_method :run_command_p, :run_command #oweridded in mixin
            alias_method :run_p, :run #oweridded in mixin
            include(Chef::Mixin::Command)

            def initialize(user = nil, sh = 'bash -l', &setup_block)
              @user = user
              super(sh, &setup_block)
            end

            # Runs a given command in the current shell.
            # Defaults the command to true if empty.
            def run(command, *arguments)
              Chef::Log.debug("Run command #{command} with #{arguments}")
              run_p(command, *arguments)
            end


            # Runs a given command in the current shell.
            # Defaults the command to true if empty.
            def run_command(command)
              Chef::Log.debug("#{self.class.name} executing: [#{wrapped_command(command)}]")
              run_command_p(command)
            end

            # Runs a command, ensuring no output is collected.
            def run_command_silently(command)
              Chef::Log.debug("#{self.class.name} silently executing: [#{wrapped_command(command)}]")
              super(command)
            end

            protected

            # yields stdio, stderr and stdin for a shell instance.
            # If there isn't a current shell instance, it will create a new one.
            # In said scenario, it will also cleanup once it is done.
            def with_shell_instance(&blk)
              Chef::Log.debug("#{self.class.name} with_shell_instance")
              no_current = @current.nil?
              if no_current
                Chef::Log.debug("#{self.class.name} subprocess executing with environment of: [#{shell_params.inspect}].")
                @current = popen4(self.shell_executable, shell_params)
                invoke_setup!
              end
              yield
            ensure
              @current = nil if no_current
            end

            def shell_params
              return {} if @user.nil?
              {
                :user => @user,
                :environment => {
                  'USER' => @user,
                  'HOME' => Etc.getpwnam(@user).dir
                }
              }
            end

            def stdin; @current[1]; end
            def stdout; @current[2]; end
            def stderr; @current[3]; end
          end
          klass.new(*args)
        end
      end
    end
  end
end
