class RvmCookbook
  class UserShellWrapper
    def self.new(*args)
      klass = Class.new(::RVM::Shell::SingleShotWrapper) do
        if RUBY_PLATFORM =~ /mswin|mingw32|windows/
          include ::Chef::Mixin::Command::Windows
        else
          include ::Chef::Mixin::Command::Unix
        end
        include ::RvmCookbook::EnvironmentMixin

        def initialize(user = nil, sh = 'bash -l', &setup_block)
          @user = user
          super(sh, &setup_block)
        end

        # Runs a given command in the current shell.
        # Defaults the command to true if empty.
        def run_command(command)
          Chef::Log.debug("Run command: \"#{wrapped_command(command)}\"")
          status, out, err = super(command)
          Chef::Log.debug("STDOUT: #{out}")
          Chef::Log.debug("STDERR: #{err}") unless err.to_s.empty?
          [status, out, err]
        end

        # Runs a command, ensuring no output is collected.
        def run_command_silently(command)
          Chef::Log.debug("Run command silently: \"#{wrapped_command(command)}\"")
          super(command)
        end

        protected

        # yields stdio, stderr and stdin for a shell instance.
        # If there isn't a current shell instance, it will create a new one.
        # In said scenario, it will also cleanup once it is done.
        def with_shell_instance(&_blk)
          no_current = @current.nil?
          if no_current
            Chef::Log.debug("subprocess executing with environment of: \"#{shell_params.inspect}\".")
            @current = popen4(shell_executable, shell_params)
            invoke_setup!
          end
          yield
        ensure
          @current = nil if no_current
        end

        def stdin
          @current[1]
        end

        def stdout
          @current[2]
        end

        def stderr
          @current[3]
        end
      end
      klass.new(*args)
    end
  end
end
