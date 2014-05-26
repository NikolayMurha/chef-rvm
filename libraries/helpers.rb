class Chef
  class Cookbook
    class RVM
      module Helpers
        def _version
          @_version ||= self.version.split('@')[0]
        end

        def _gemset
          @_gemset ||= (self.version.split('@')[1] || 'default')
        end
      end
    end
  end
end

