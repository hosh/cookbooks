#
# Use this to exclude categories during emerge --sync
# ... no, you really don't need nethack on your cloud server ...
#
# Author:: Ho-Sheng Hsiao <hosh@sparkfly.com>
# Source:: http://www.gentoo-wiki.info/TIP_Exclude_categories_from_emerge_sync
# Cookbook Name:: gentoo
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

include_recipe 'gentoo::portage'

template node[:gentoo][:rsync][:exclude_rsync_file] do
  owner 'portage'
  group 'portage'
  mode '0755'
  source 'rsync_excludes.erb'
  variables(:exclude_categories => node[:gentoo][:rsync][:exclude_categories])
end

portage_conf :rsync_excludes, :appends => [ :PORTAGE_RSYNC_EXTRA_OPTS, "--exclude-from=#{node[:gentoo][:rsync][:exclude_rsync_file]}" ]
