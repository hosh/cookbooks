#
# Adds a cron job for eix sync
# Do not add this if you are using emerge --sync, use cron_emerge_sync recipe instead
#
# cron_eix_sync uses the same attributes as cron_emerge_sync:
#   gentoo.cron.emerge_sync.always_upgrade_portage 
#   gentoo.cron.emerge_sync.hour
#   gentoo.cron.emerge_sync.minute
#
# Author:: Ho-Sheng Hsiao <hosh@sparkfly.com>
# Source:: http://anothersysadmin.wordpress.com/2007/12/05/eix-enhancing-the-gentoo-experience/
# Cookbook Name:: gentoo
# Recipe:: cron_eix_sync
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

eix_sync_command = [ "eix-sync" ]
eix_sync_command << "emerge -q -g -u portage" if emerge_sync[:always_upgrade_portage]

cron "eix_sync" do
  hour    emerge_sync[:hour]
  minute  emerge_sync[:minute]
  command eix_sync_command.join(' && ')
end
