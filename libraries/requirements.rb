class ChefRvmCookbook
  module Requirements
    module Cache
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

    def requirements_install(ruby_string)
      ruby_string = RubyString[ruby_string]
      pkgs = if ruby_string.version.to_s =~ /^jruby/
               return if Cache.get('jruby')
               Cache.set('jruby', 1)
               jruby_requirements
             elsif ruby_string.version.to_s =~ /^opal/
               Cache.set('opal', 1)
               opal_requirements
             else
               Cache.set('ruby', 1)
               ruby_requirements(ruby_string)
             end

      Chef::Log.debug("Install ruby requirements for version #{ruby_string.version}")
      pkgs.each do |pkg|
        package pkg do
          action :nothing
        end.run_action(:install)
      end
    end

    def jruby_requirements
      begin
        resource_collection.find('bash[update-java-alternatives]').run_action(:run)
      rescue Chef::Exceptions::ResourceNotFound
        Chef::Log.debug('Java cookbook not loaded or not on ubuntu/debian, so skipping')
      end

      # TODO: need to figure out how to pull in java recipe only when needed. For
      # now, users of jruby will have to add the "java" recipe to their run_list.
      # include_recipe "java"
      pkgs = []
      pkgs += %w(g++ ant) if %w(debian ubuntu).include?(node['platform'])
      pkgs
    end

    def opal_requirements
      []
    end

    def ruby_requirements(ruby_string)
      ruby_string = RubyString[ruby_string]
      pkgs = value_for_platform(
        %w(debian ubuntu) => {
          'default' => %w(build-essential openssl libreadline6 libreadline6-dev
                          zlib1g zlib1g-dev libssl-dev libyaml-dev libsqlite3-dev
                          sqlite3 libxml2-dev libxslt-dev autoconf libc6-dev gawk ncurses-dev
                          automake libtool bison ssl-cert pkg-config libgdbm-dev libffi-dev clang llvm llvm-dev libedit-dev libgmp-dev
                          patch ca-certificates curl libncurses5-dev)
        },
        'suse' => {
          'default' => %w( automake binutils bison bzip2 libtool m4 make patch gdbm-devel glibc-devel libffi-devel
                  libopenssl-devel readline-devel zlib-devel sqlite3-devel
                  gcc-c++ zlib libxml2-devel libxslt-devel llvm llvm-clang llvm-devel )
        },
        %w(centos redhat fedora scientific amazon) => {
          'default' => %w(gcc-c++ patch readline readline-devel zlib zlib-devel
                          libyaml-devel libffi-devel openssl-devel
                          make bzip2 autoconf automake libtool bison
                          libxml2 libxml2-devel libxslt libxslt-devel)
        },

        'gentoo' => {
          'default' => %w(libiconv readline zlib openssl libyaml sqlite libxslt libtool gcc autoconf automake bison m4)
        },
        'default' => []
      )

      pkgs += value_for_platform(
        'suse' => {
          '>= 12.0' => %w(libreadline5 libopenssl-devel libdb-4_8),
          '>= 11.0' => %w(libreadline5 libopenssl-devel libdb-4_5),
          'default' => %w(readline openssl-devel)
        },
        'default' => []
      )

      pkgs += value_for_platform(
        %w(debian ubuntu) => %w(subversion),
        %w(suse centos redhat fedora scientific amazon) => %w(git subversion autoconf),
        'gentoo' => %w(libiconv readline zlib openssl libyaml sqlite libxslt libtool gcc autoconf automake bison m4),
        'default' => []
      ) if ruby_string.version =~ /head$/
      pkgs
    end
  end
end
