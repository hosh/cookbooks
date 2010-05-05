#
# Use this to setup a site rsync mirror. Use the local_portage_rsync recipe
# to actually point to this server.
#
# Author:: Ho-Sheng Hsiao <hosh@sparkfly.com>
# Source:: http://www.gentoo-wiki.info/TIP_Exclude_categories_from_emerge_sync
# Cookbook Name:: gentoo
# Recipe:: portage_rsync_server
#
# Copyright 2010, Sparkfly
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

include_recipe 'gentoo::portage'

template '/etc/rsyncd.conf' do
  owner 'root'
  group 'root'
  mode '0644'
  source 'rsyncd.conf.erb'
  variables(:rsyncd => node[:gentoo][:rsyncd])
end

service 'rsyncd' do
  supports :restart => true
  action :start
  subscribes :restart, resources(:template => '/etc/rsyncd.conf'), :immediately
end

# Pattern taken from: http://github.com/engineyard/ey-cloud-recipes/blob/master/cookbooks/ntp/recipes/default.rb
execute "add-rsyncd-to-default-run-level" do
  command "rc-update add rsyncd default"
  not_if "rc-status | grep rsyncd"
end

