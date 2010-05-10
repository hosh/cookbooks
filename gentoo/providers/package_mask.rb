include Opscode::Gentoo::Portage

action :create do
  manage_package_conf(:create, "mask", new_resource.package)
end

action :delete do
  manage_package_conf(:delete, "mask", new_resource.package)
end
