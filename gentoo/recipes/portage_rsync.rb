#
# Use this to sync to a local portage mirror. Use the portage_rsync_server recipe
# to actually set up a mirror
#
# Author:: Ho-Sheng Hsiao <hosh@sparkfly.com>
# Source:: http://www.gentoo.org/doc/en/rsync.xml#doc_chap2
# Cookbook Name:: gentoo
# Recipe:: portage_rsync
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

if node[:gentoo][:rsync][:uri] && node[:gentoo][:rsync][:uri].any?
  include_recipe 'gentoo::portage'

  log "Setting portage sync to: #{node[:gentoo][:rsync][:uri]}"

  portage_conf :portage_rsync do
    overrides [ :SYNC, node[:gentoo][:rsync][:uri] ]
  end
else
  log "No rsync defined, defaulting to system setting."

  portage_conf :portage_rsync
end
