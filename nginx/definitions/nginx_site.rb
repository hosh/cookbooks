#
# Cookbook Name:: nginx
# Definition:: nginx_site
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

define :nginx_available_site, :no_reload => false, :variables => nil do
  template "#{node[:nginx][:dir]}/sites-available/#{params[:name]}" do
    owner 'root'
    group 'root'
    mode '0644'
    source "#{params[:name]}.nginx-site.erb"
    variables(params[:variables]) if params[:variables]
    notifies :reload, resources(:service => 'nginx') unless params[:no_reload]
  end
end

define :nginx_site, :enable => true do

  if params[:enable]
    execute "nginx-enable-site #{params[:name]}" do
      command "/usr/sbin/nginx-enable-site #{params[:name]}"
      notifies :reload, resources(:service => "nginx")
      not_if do File.symlink?("#{node[:nginx][:dir]}/sites-enabled/#{params[:name]}") end
    end
  else
    execute "nginx-disable-site #{params[:name]}" do
      command "/usr/sbin/nginx-disable-site #{params[:name]}"
      notifies :reload, resources(:service => "nginx")
      only_if do File.symlink?("#{node[:nginx][:dir]}/sites-enabled/#{params[:name]}") end
    end
  end
end
