class RvmCookbook
  class Cache
    class << self
      def get(key)
        storage[key]
      end

      def set(key, value)
        storage[key] = value
      end

      def storage
        @storage ||= {}
      end
    end
  end
end
