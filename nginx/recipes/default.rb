#
# Cookbook Name:: nginx
# Recipe:: default
# Author:: AJ Christensen <aj@junglist.gen.nz>
#
# Copyright 2008-2009, Opscode, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

case node[:platform]
when "gentoo"
  nginx_package = 'www-servers/nginx'
  use_flags :nginx do
    package nginx_package
    flags node[:nginx][:use_flags] 
  end
  emerge nginx_package
else
  package "nginx"
end

directory node[:nginx][:log_dir] do
  mode 0755
  owner node[:nginx][:user]
  action :create
end

%w{nginx-enable-site nginx-disable-site}.each do |nxscript|
  template "/usr/sbin/#{nxscript}" do
    source "#{nxscript}.erb"
    mode 0755
    owner "root"
    group "root"
  end
end

template "nginx.conf" do
  path "#{node[:nginx][:dir]}/nginx.conf"
  source "nginx.conf.erb"
  owner "root"
  group "root"
  mode 0644
end

# Because not all platforms installs this
directory "#{node[:nginx][:dir]}/sites-available" do
  action :create
  not_if "test -d #{node[:nginx][:dir]}/sites-available"
end

directory "#{node[:nginx][:dir]}/sites-enabled" do
  action :create
  not_if "test -d #{node[:nginx][:dir]}/sites-enabled"
end

template "#{node[:nginx][:dir]}/sites-available/default" do
  source "default-site.erb"
  owner "root"
  group "root"
  mode 0644
end

service "nginx" do
  supports :status => true, :restart => true, :reload => true
  action [ :enable, :start ]
end

case node[:platform]
when 'gentoo'
  rc_update_add :nginx
else
end
