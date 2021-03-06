#
# Adds a cron job for emerge --sync
# Do not use this if you are using eix, use cron_eix_sync recipe instead
#
# Author:: Ho-Sheng Hsiao <hosh@sparkfly.com>
# Cookbook Name:: gentoo
# Recipe:: cron_emerge_sync
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

emerge_sync = node[:gentoo][:cron][:emerge_sync]

emerge_sync_command = [ "emerge -q --sync" ]
emerge_sync_command << "emerge -q -g -u portage" if emerge_sync[:always_upgrade_portage]

cron "emerge_sync" do
  hour    emerge_sync[:hour]
  minute  emerge_sync[:minute]
  command emerge_sync_command.join(' && ')
end
