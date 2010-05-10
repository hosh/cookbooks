
# Reopens and overrides Chef::Provider::Package::Portage
# Works with Chef 0.8.10

class Chef
  class Provider
    class Package
      class Portage < Chef::Provider::Package

        # Override this in your libraries/
        def default_emerge_options(options)
          "--color n --nospinner --quiet #{options}"
        end
        
        # Override this in your libraries/
        def default_emerge_install_options
          default_emerge_options('-g --binpkg-respect-use y')
        end

        # Override this in your libraries/
        def default_emerge_upgrade_options
          default_emerge_options('-g --binpkg-respect-use y -u -D')
        end

        def emerge_package(pkg, emerge_options = nil)
          emerge_options ||= default_emerge_install_options
          "emerge #{emerge_options} #{expand_options(@new_resource.options)} #{pkg}"
        end

        def full_package_name(name, version)
          if(version =~ /^\~(.+)/)        
            # If we start with a tilde      
            "~#{name}-#{$1}"          
          else
            "=#{name}-#{version}"     
          end
        end

        def install_package(name, version)
          run_command_with_systems_locale( 
            :command => emerge_package(full_package_name(name, version), default_emerge_install_options))
        end

        def upgrade_package(name, version)
          run_command_with_systems_locale( 
            :command => emerge_package(full_package_name(name, version), default_emerge_upgrade_options))
        end
      end
    end
  end
end

