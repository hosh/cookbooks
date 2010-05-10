#
# Installs eix for use with gentoo_package providers
#
# Author:: Gábor Vészi <veszig@done.hu>
# Source :: http://github.com/veszig/gentoo-cookbooks/tree/0cd06acc5b8e4b2bb855f51430b4a8a66de23023/eix/recipes/default.rb

execute "eix-update" do
  command "/usr/bin/eix-update"
  action :nothing
end

package "app-portage/eix" do
  action :upgrade
  notifies :run, resources(:execute => "eix-update")
end
