
# Reopens and overrides Chef::Provider::Package::Portage
# Works with Chef 0.8.10

class Chef
  class Provider
    class Package
      class Portage < Chef::Provider::Package
        include ::Gentoo::Portage::Emerge

        def install_package(name, version)
          conditional_emerge(new_resource, :install)
        end

        def upgrade_package(name, version)
          conditional_emerge(new_resource, :upgrade)
        end

        def candidate_version
          @candidate_verison ||= self.package_info[:candidate_version]
        end

      end
    end
  end
end

