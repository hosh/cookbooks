#
# This recipe installs mirrorselect and configures the three fastest mirrors using
# the technique described at http://en.gentoo-wiki.com/wiki/Mirrorselect
#
# Author:: Ho-Sheng Hsiao <hosh@sparkfly.com>
# Source:: http://www.gentoo-wiki.info/TIP_Exclude_categories_from_emerge_sync
# Cookbook Name:: gentoo
# Recipe:: mirrorselect
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

emerge 'mirrorselect'

log 'Starting mirror select. This might take a while.' do
  not_if "test -f #{node[:gentoo][:mirrorselect_conf]}"
end

execute 'mirrorselect' do
  command "mirrorselect -s3 -b10 -o -D >> #{node[:gentoo][:mirrorselect_conf]}" 
  creates node[:gentoo][:mirrorselect_conf]
end

# make.conf must be regenerated *after* mirrors are selected, otherwise portage 
# will be in a state unable to emerge mirrorselect
portage_conf :mirrorselect do
  sources [ node[:gentoo][:mirrorselect_conf] ]
  force_regen true 
end
