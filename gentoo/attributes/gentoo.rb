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

case platform
when 'gentoo'
  # Directories
  set[:gentoo][:portage_dir] = '/etc/portage'
  set[:gentoo][:portage_chef_dir] = "#{set[:gentoo][:portage_dir]}/chef"

  # Gentoo Packages (e.g. /etc/portage/package.use)
  [:keywords, :unmask, :mask, :use].each do |control_file|
    set[:gentoo][:package][control_file] = "#{set[:gentoo][:portage_dir]}/package.#{control_file}"
  end

  # emerge --sync settings
  set[:gentoo][:rsync][:exclude_rsync_file] = "#{set[:gentoo][:portage_chef_dir]}/rsync_excludes"
  default[:gentoo][:rsync][:exclude_categories] = %w(
    games-*
    dev-games/
    app-cdr/
    app-laptop/
    app-mobilephone/
    app-office/
    app-pda/
    gnome-*
    gnustep-*
    gpe-*
    media-radio/
    media-sound/
    media-tv/
    kde-*
    rox-*
    x11-apps/
    x11-base/
    x11-drivers/
    x11-misc/
    x11-plugins/
    x11-terms/
    x11-themes/
    x11-wm/
    xfce-*
  )
  
else
  raise "This cookbook is Gentoo-only"
end
