class RvmCookbook
  class ShellHelper
    include Chef::Mixin::DeepMerge
    include ::RvmCookbook::EnvironmentMixin
    attr_reader :ruby_string, :opts

    def initialize(*args)
      @opts = args.pop if args.last.is_a?(Hash)
      @user = args.shift
      @ruby_string = args.shift
      @opts = opts
    end

    def shell_out_args(*args)
      options = args.last.is_a?(Hash) ? params(args.pop) : nil
      commands = args.map { |cmd| command(cmd) }
      commands.push(options) if options
      commands
    end

    def command(cmd)
      return cmd unless @ruby_string
      cmd = cmd.split(' && ').map do |cmd_part|
        if cmd_part[0..2] == 'cd '
          cmd_part
        else
          "rvm #{@ruby_string} do #{cmd_part}"
        end
      end.unshift("source #{rvm_path}/scripts/rvm").join(' && ').strip
      "bash -c \"#{cmd.gsub('"', '\"')}\""
    end

    def params(options = {})
      return options unless user && @ruby_string
      merge(shell_params, options).symbolize_keys
    end

    def method_missing(name)
      params[name]
    end

    def rvm_path
      if @user.nil?
        RvmCookbook::Environment.root_rvm_path || '/usr/local/rvm'
      else
        File.join(Etc.getpwnam(@user).dir, '.rvm')
      end
    end
  end
end
