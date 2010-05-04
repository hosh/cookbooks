#
# Author:: Ho-Sheng Hsiao <hosh@sparkfly.com>
# Cookbook Name:: portage
# Recipe:: make_conf
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

template node[:gentoo][:extra_portage_conf] do
  owner 'root'
  group 'root'
  mode '0755'
  source 'chef_make.conf.erb'
  variables(:extra_portage_conf_dir => node[:gentoo][:extra_portage_conf_dir],
            :sources => Utils::Gentoo::PortageConfs.confs)
end

execute :reset_make_conf do
  command "rm -f #{node[:gentoo][:extra_portage_conf]} && touch #{node[:gentoo][:extra_portage_conf]}"
  action :nothing
  notifies :create, resources(:template => node[:gentoo][:extra_portage_conf]), :immediately
end
