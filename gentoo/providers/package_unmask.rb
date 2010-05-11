include Gentoo::Portage

action :create do
  manage_package_conf(:create, "unmask", new_resource.package)
end

action :delete do
  manage_package_conf(:delete, "unmask", new_resource.package)
end
