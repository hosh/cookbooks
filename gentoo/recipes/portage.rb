#
# Author:: Ho-Sheng Hsiao <hosh@sparkfly.com>
# Cookbook Name:: portage
# Recipe:: exclude_categories
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

directory node[:gentoo][:portage_chef_dir] do
  owner 'root'
  group 'root'
  mode '0755'
  action :create
  not_if "test -d #{node[:gentoo][:portage_chef_dir]}"
end

[:keywords, :unmask, :mask, :use].each do |control_file|
  
  # If we are applying this to a legacy system, we want to make sure the old
  # portage control files gets backed up
  old_control_file = node[:gentoo][:package][control_file]
  new_control_file = "local_#{control_file}"
  backup = "#{node[:gentoo][:portage_dir]}/#{new_control_file}"

  bash "backup-package-#{control_file}" do
    code "mv #{old_control_file} #{backup}"
    only_if "test -f #{old_control_file}"
  end

  control_dir = old_control_file

  directory control_dir do
    owner 'root'
    group 'root'
    mode '0755'
    action :create
    not_if "test -d #{control_dir}"
  end

  bash "restore-package-#{control_file}" do
    code "mv #{backup} #{control_dir}/#{new_control_file}"
    only_if "test -f #{backup}"
  end
end

template node[:gentoo][:make_conf] do
  owner 'root'
  group 'root'
  mode '0755'
  source 'make.conf.erb'
  variables(:portage => node[:gentoo][:portage], :extra_portage_conf => node[:gentoo][:extra_portage_conf])
end

directory node[:gentoo][:extra_portage_conf_dir] do
  owner 'root'
  group 'root'
  mode '0755'
  action :create
  not_if "test -d #{node[:gentoo][:extra_portage_conf_dir]}"
end

