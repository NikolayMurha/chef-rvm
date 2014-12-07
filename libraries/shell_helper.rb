class RvmCookbook
  class ShellHelper
    include Chef::Mixin::DeepMerge
    include ::RvmCookbook::EnvironmentMixin
    attr_reader :ruby_string, :opts

    def initialize(*args)
      if args.last.is_a?(Hash)
        @opts = args.pop
      end
      @user = args.shift
      @ruby_string = args.shift
      @opts = opts
    end

    def shell_out_args(*args)
      _options = args.last.is_a?(Hash) ? params(args.pop) : nil
      commands = args.map { |cmd| command(cmd) }
      commands.push(_options) if _options
      commands
    end

    def command(cmd)
      return cmd unless @ruby_string
      cmd = cmd.split(' && ').map do |_cmd|
        if _cmd[0..2] == 'cd '
          _cmd
        else
          "rvm #{@ruby_string} do #{_cmd}"
        end
      end.unshift("source #{rvm_path}/scripts/rvm").join(' && ').strip
      "bash -c \"#{cmd.gsub('"', '\"')}\""
    end

    def params(options = {})
      return options unless user && @ruby_string
      merge(shell_params, options).symbolize_keys
    end

    def method_missing(name, *args)
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
