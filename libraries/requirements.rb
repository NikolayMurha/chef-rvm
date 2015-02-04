class RvmCookbook
  module Requirements
    def requirements_install(rubie)
      pkgs = []
      Chef::Log.debug("Install ruby for version #{rubie}")
      case rubie
        when /^jruby/
          return if RvmCookbook::Cache.get('jruby')
          RvmCookbook::Cache.set('jruby', 1)
          begin
            resource_collection.find('ruby_block[update-java-alternatives]').run_action(:create)
          rescue Chef::Exceptions::ResourceNotFound
            Chef::Log.debug('Java cookbook not loaded or not on ubuntu/debian, so skipping')
          end

          # TODO: need to figure out how to pull in java recipe only when needed. For
          # now, users of jruby will have to add the "java" recipe to their run_list.
          # include_recipe "java"
          case node['platform']
            when 'debian', 'ubuntu'
              pkgs += %w(g++ ant)
          end
        else # /^ruby-/, /^ree-/, /^rbx-/, /^kiji/
          return if RvmCookbook::Cache.get('ruby')
          RvmCookbook::Cache.set('ruby', 1)
          case node['platform']
            when 'debian', 'ubuntu'
              pkgs = %w(build-essential openssl libreadline6 libreadline6-dev
                    zlib1g zlib1g-dev libssl-dev libyaml-dev libsqlite3-dev
                    sqlite3 libxml2-dev libxslt-dev autoconf libc6-dev gawk ncurses-dev
                    automake libtool bison ssl-cert pkg-config libgdbm-dev libffi-dev)
              pkgs += %w(subversion) if rubie =~ /^ruby-head$/
            when 'suse'
              pkgs = %w(gcc-c++ patch zlib zlib-devel libffi-devel
                    sqlite3-devel libxml2-devel libxslt-devel)
              if node['platform_version'].to_f >= 11.0
                pkgs += %w(libreadline5 readline-devel libopenssl-devel)
              else
                pkgs += %w(readline readline-devel openssl-devel)
              end
              pkgs += %w(git subversion autoconf) if rubie =~ /^ruby-head$/
            when 'centos', 'redhat', 'fedora', 'scientific', 'amazon'
              pkgs = %w(gcc-c++ patch readline readline-devel zlib zlib-devel
                    libyaml-devel libffi-devel openssl-devel
                    make bzip2 autoconf automake libtool bison
                    libxml2 libxml2-devel libxslt libxslt-devel)
              pkgs += %w(git subversion autoconf) if rubie =~ /^ruby-head$/
            when 'gentoo'
              pkgs = %w(libiconv readline zlib openssl libyaml sqlite libxslt libtool gcc autoconf automake bison m4)
          end
      end
      Chef::Log.debug("Install rvm ruby requirements #{pkgs} for #{rubie}")
      pkgs.each do |pkg|
        package pkg do
          action :nothing
        end.run_action(:install)
      end
    end
  end
end
