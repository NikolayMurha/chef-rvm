class Chef
  class Cookbook
    class RVM
      module Helpers
        module RubyString
          def self.normalize_ruby_version(ruby)
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

          def normalize_ruby_version(ruby)
            self.class.normalize_ruby_version(ruby)
          end
        end

        def _version
          @_version ||= self.ruby_version.split('@')[0]
        end

        def _gemset
          @_gemset ||= (self.ruby_version.split('@')[1] || 'default')
        end

        def ruby_version
          if self.respond_to?(:ruby_string)
            self.ruby_string
          else
            self.version
          end
        end
      end
    end
  end
end

