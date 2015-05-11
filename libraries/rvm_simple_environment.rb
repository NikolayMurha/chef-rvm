require 'shellwords'
require_relative 'ruby_string'
require_relative 'rvm_simple_environment/rvm'
require_relative 'rvm_simple_environment/ruby'
require_relative 'rvm_simple_environment/gemset'
require_relative 'rvm_simple_environment/gem'
require_relative 'rvm_simple_environment/alias'

class ChefRvmCookbook
  class RvmSimpleEnvironment
    include Chef::Mixin::ShellOut
    alias_method :parent_shell_out, :shell_out
    attr_accessor :options
    attr_accessor :user

    def initialize(user, options = {})
      self.options = options
      self.user = user
      raise RvmUserRequired unless user
    end

    def ruby_string(ruby_string)
      RubyString[ruby_string]
    end

    def shell_out(*args)
      command = *shell(*args)
      Chef::Log.debug("RVM Execute: \"#{command[0]}\" with options #{command[1]}") if options[:verbose]
      resp = parent_shell_out(*command)
      if options[:verbose]
        Chef::Log.debug("RVM Execute STDOUT: #{resp.stdout}")
        Chef::Log.debug("RVM Execute STDERR: #{resp.stderr}")
      end
      resp
    end

    def shell_options
      {
        user: user,
        env: env
      }
    end

    def shell(*args)
      check_rvm!
      options = extract_options(args)
      cmd = args.flatten.join(' ')
      cmd = "source #{rvm_path}/scripts/rvm; #{cmd}"
      ["bash -c #{Shellwords.escape(cmd)}", merged_options(options)]
    end

    def merged_options(options)
      opts = shell_options.merge(options)
      opts[:env] = (options[:env] || {}).merge(shell_options[:env])
      opts
    end

    def env
      env ||= {}
      env.merge!(
                   'USER' => user,
                   'HOME' => user_home,
                   'rvm_path' => rvm_path
                 ) if user
      env
    end

    def rvm_path
      system? ? '/usr/local/rvm' : "#{user_home}/.rvm"
    end

    def user_home
      Etc.getpwnam(user).dir
    end

    def system?
      user == 'root'
    end

    def extract_options(args)
      args.last.is_a?(Hash) ? args.slice!(-1) : {}
    end
  end

  class RvmUserRequired < ::Exception
  end

  class RvmDoesNotInstalled < ::Exception
  end

  class RubyDoesNotInstalled < ::Exception
    attr_accessor :ruby_version

    def initialize(message = '', ruby_version = nil)
      super(message)
      self.ruby_version = ruby_version
    end
  end

  class RvmGemsetDoesNotExist < ::Exception
    attr_accessor :ruby_version
    attr_accessor :gemset
  end
end
