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

    def initialize(*args)
      self.options = extract_options(args)
      self.user = args[0]
      raise UserRequired.new unless user
      self.ruby_string = args[1]
    end

    def ruby_string=(ruby_string)
      return unless ruby_string
      @ruby_string = RubyString[ruby_string]
    end

    alias_method :use, :ruby_string=

    def ruby_string(ruby_string=nil)
      ruby_string = RubyString.fetch(ruby_string) if ruby_string.is_a?(Array)
      ruby_string = if @ruby_string
        @ruby_string.merge(ruby_string)
      else
        RubyString[ruby_string]
      end
      raise 'Ruby string not is not defined. You need define a default ruby_string.' unless ruby_string
      ruby_string
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
      raise RvmDoesNotInstalled.new unless rvm?
      options = extract_options(args)
      cmd = args.flatten.join(' ')
      cmd = "source #{rvm_path}/scripts/rvm; #{cmd}"
      ["bash -c #{Shellwords.escape(cmd)}", merged_options(options)]
    end

    def merged_options(options)
      opts = self.shell_options.merge(options)
      opts[:env] = (options[:env] || {}).merge(self.shell_options[:env])
      opts
    end

    def env
      env ||= {}
      env.merge!({
          'USER' => user,
          'HOME' => user_home,
          'rvm_path' => rvm_path
        }) if user
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

  class UserRequired < ::Exception
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

  class GemsetDoesNotExist < ::Exception
    attr_accessor :ruby_version
    attr_accessor :gemset
  end
end


# rvm = RvmSimpleEnvironment.new({ :user => 'ubuntu', use: '' })
# rvm.use('2.0.0') # set default ruby
#
# rvm.do('2.0.0@default"', 'rvm list')
# rvm.in(direcotry)
#
# rvm.gemset?('2.0.0@iptables-web')
# rvm.gemset_create('2.0.0@iptables-web')
# rvm.gemset_delete('2.2.0@iptables-web')
#
# rvm.ruby?('2.0.0')
# rvm.ruby_install('2.0.0')
# rvm.ruby_remove('2.0.0')
#
# rvm.gem?('2.0.0@default', 'eye', '0.6.4')
# rvm.gem_install('2.0.0')
# rvm.gem_uninstall('2.0.0')
#
# rvm.alias?('my_alias')
# rvm.alias_create('2.0.0@default', 'myalias')
# rvm.alias_delete('myalias')
# rvm.shell_out()
#
# # exceptions
# RvmEnvitonment::RvmDidNotInstalled
# RvmEnvitonment::RubyDidNotInstalled
# RvmEnvitonment::GemsetDoNotExist

