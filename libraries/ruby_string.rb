class ChefRvmCookbook
  class RubyString
    attr_accessor :version
    attr_accessor :gemset
    attr_accessor :ruby_string

    RUBY_VERSIONS = %w(system)

    def initialize(ruby_string = nil)
      self.ruby_string = ruby_string if ruby_string
    end

    def ruby_string=(ruby_string)
      @ruby_string = ruby_string.to_s
      self.version, self.gemset = self.ruby_string.split('@')
    end

    def gemset(default = 'default')
      @gemset || default
    end

    def version(default = 'system')
      @version || default
    end

    def to_s
      return version if version == 'system'
      "#{version}@#{gemset}"
    end

    def head?
      self.ruby_string =~ /head$/
    end

    def merge(ruby_string)
      rb = RubyString[ruby_string]
      rb.version = rb.version(version)
      rb.gemset = rb.gemset(gemset)
      rb
    end

    alias_method :+, :merge

    class << self
      def [](ruby_string)
        return ruby_string if ruby_string.is_a?(RubyString)
        new(ruby_string)
      end
    end
  end
end

=begin
# MRI Rubies
[ruby-]1.8.6[-p420]
[ruby-]1.8.7[-head] # security released on head
[ruby-]1.9.1[-p431]
[ruby-]1.9.2[-p330]
[ruby-]1.9.3[-p551]
[ruby-]2.0.0[-p643]
[ruby-]2.1.4
[ruby-]2.1[.5]
[ruby-]2.2[.1]
[ruby-]2.2-head
ruby-head

# for forks use: rvm install ruby-head-<name> --url https://github.com/github/ruby.git --branch 2.1

# JRuby
jruby-1.6.8
jruby[-1.7.19]
jruby-head
jruby-9.0.0.0.pre1

# Rubinius
rbx-1.4.3
rbx-2.4.1
rbx[-2.5.2]
rbx-head

# Opal
opal

# Minimalistic ruby implementation - ISO 30170:2012
mruby[-head]

# Ruby Enterprise Edition

ree-1.8.6
ree[-1.8.7][-2012.02]

# GoRuby
goruby

# Topaz
topaz

# MagLev
maglev[-head]
maglev-1.0.0

# Mac OS X Snow Leopard Or Newer
macruby-0.10
macruby-0.11
macruby[-0.12]
macruby-nightly
macruby-head

# IronRuby
ironruby[-1.1.3]
ironruby-head
=end
