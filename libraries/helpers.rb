class RvmCookbook
  module Helpers
    module RubyString
      def normalize_ruby_version(ruby)
        version = {
          version: ruby,
          patch: nil,
          default: false,
        }
        if ruby.is_a?(Hash)
          version[:version] = ruby['version']
          version[:default] = ruby['default']
          version[:patch] = ruby['patch']
        end
        version
      end
    end

    def _version
      @_version ||= ruby_version.split('@')[0]
    end

    def _gemset
      @_gemset ||= (ruby_version.split('@')[1] || 'default')
    end

    def ruby_version
      if self.respond_to?(:ruby_string)
        ruby_string
      else
        version
      end
    end
  end
end
