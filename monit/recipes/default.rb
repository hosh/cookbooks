monit_package = case node[:platform]
  when 'gentoo'
    'app-admin/monit'
  else
    'monit'
  end

package monit_package do
  action :upgrade
end

directory "/etc/monit.d" do
  owner "root"
  group "root"
  mode "0700"
end

# Make sure there is always a file in /etc/monit.d
file "/etc/monit.d/empty-keep" do
  owner "root"
  group "root"
  mode "0700"
  action :touch
end

template "/etc/monitrc" do
  source "monitrc.erb"
  owner "root"
  group "root"
  mode "0600"
  variables(
    :mailservers => [node[:monit][:mailservers]].flatten,
    :from => node[:monit][:alert_mail_from],
    :to => node[:monit][:alert_mail_to]
  )
end

service "monit" do
  supports :status => true, :restart => true, :reload => true
  action [ :enable, :start ]
  subscribes :reload, resources(:template => "/etc/monitrc")
  subscribes :restart, resources(:package => monit_package)
  ignore_failure true
end

if node.recipe?("nagios::nrpe")
  nrpe_command "monit"
end
