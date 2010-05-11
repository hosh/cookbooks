
# Reopens and overrides Chef::Provider::Package::Portage
# Works with Chef 0.8.10

class Chef
  class Provider
    class Package
      class Portage < Chef::Provider::Package
        include Gentoo::Portage::Emerge

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

