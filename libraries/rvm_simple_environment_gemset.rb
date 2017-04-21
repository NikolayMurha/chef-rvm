class ChefRvmCookbook
  class RvmSimpleEnvironment
    module Gemset
      def gemset?(*args)
        ruby_string = _gemset_ruby_string(*args)
        !rvm(ruby_string.to_s).error?
      end

      %i[create prune pristine].each do |action|
        define_method "gemset_#{action}" do |*args|
          ruby_string = _gemset_ruby_string(*args)
          check_ruby!(ruby_string)
          cmd = self.do(ruby_string.version, :rvm, :gemset, action, ruby_string.gemset)
          cmd.error!
          cmd
        end
      end

      def gemset_delete(*args)
        ruby_string = _gemset_ruby_string(*args)
        check_ruby!(ruby_string)
        shell_out!('echo yes | rvm', ruby_string.version, :do, :rvm, :gemset, :delete, ruby_string.gemset)
      end

      def _gemset_ruby_string(ruby_string, gemset = nil)
        ruby_string = self.ruby_string(ruby_string)
        ruby_string.gemset = gemset if gemset
        ruby_string
      end

      def check_gemset!(ruby_string)
        check_ruby!(ruby_string)
        raise RvmGemsetDoesNotExist unless gemset?(ruby_string)
      end
    end
  end
end
