class ChefRvmCookbook
  class RubyString
    attr_accessor :version
    attr_accessor :gemset
    attr_accessor :ruby_string

    def initialize(ruby_string=nil)
      self.ruby_string = ruby_string if ruby_string
    end

    def ruby_string=(ruby_string)
      ruby_string = ruby_string.to_s
      raise "Invalid ruby string #{ruby_string}!" unless self.class.valid?(ruby_string)
      self.version, self.gemset = ruby_string.split('@')
    end

    def gemset(default = 'default')
      @gemset || default
    end

    def version(default = 'system')
      @version || default
    end

    def to_s
      return version if %W(current system).include?(version)
      "#{version}@#{gemset}"
    end

    def valid?
      self.class.valid?(to_s)
    end

    def merge(ruby_string)
      rb = RubyString[ruby_string]
      rb.version = rb.version(self.version)
      rb.gemset = rb.gemset(self.gemset)
      rb
    end

    alias_method :+, :merge

    class << self
      def [](ruby_string)
        return ruby_string if ruby_string.is_a?(RubyString)
        self.new(ruby_string)
      end

      def valid?(ruby_string)
        return true if %W(current system).include?(ruby_string)
        /^(([a-z]+-){0,1})((\d+\.)?(\d+\.)?(\*|\d+))((-p[0-9]+){0,1})(@([a-zA-Z0-9_-]+)){0,1}$/.match(ruby_string)
      end

      def fetch(arr)
        valid?(arr.first.to_s) ? arr.slice!(0) : nil
      end
    end
  end
end
