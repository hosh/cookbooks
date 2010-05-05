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
  # Directories and Confs
  set[:gentoo][:portage_dir] = '/etc/portage'
  set[:gentoo][:portage_chef_dir] = "#{set[:gentoo][:portage_dir]}/chef"
  set[:gentoo][:make_conf] = '/etc/make.conf'
  set[:gentoo][:extra_portage_conf] = "#{set[:gentoo][:portage_chef_dir]}/make.conf"
  set[:gentoo][:extra_portage_conf_dir] = "#{set[:gentoo][:portage_chef_dir]}/conf.d"

  # Generic Gentoo Portage settings (for make.conf)
  #
  # Suggested CFLAGS (Assuming Gentoo 10.1 / GCC 4.3+)
  #   - Slicehost: -O2 -march=opteron
  #   - Rackspace: -O2 -march=barcelona
  #   - MacBookPros: -O2 -pipe -march=native
  #   - i5, i7 Desktops: -O2 -pipe -march=native
  #   See: http://en.gentoo-wiki.com/wiki/Safe_Cflags
  #
  # Suggested additional USE flags: mmx sse sse2
  # (Turn off piping since they eat up memory. Try to to stick to j1 for MAKEOPTS)
  # Override these in your own site-cookbook. You may also override these per-node
  default[:gentoo][:portage][:CFLAGS] = '-O2 -pipe'
  default[:gentoo][:portage][:CXXFLAGS] = '${CFLAGS}'
  default[:gentoo][:portage][:CHOST] = 'x86_64-pc-linux-gnu'
  default[:gentoo][:portage][:USE] = '-X -gnome -gtx -kde -qt unicode ipv6 idn threads'
  default[:gentoo][:portage][:MAKEOPTS] = '-j4'

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

  set[:gentoo][:mirrorselect_conf] = "#{node[:gentoo][:portage_chef_dir]}/mirrorselect"

  # Override this in roles / site attributes
  default[:gentoo][:cron][:emerge_sync][:hour]   = rand(4) + 1
  default[:gentoo][:cron][:emerge_sync][:minute] = rand(60)
  default[:gentoo][:cron][:emerge_sync][:always_upgrade_portage] = false

  # Chef-Overlay
  default[:gentoo][:overlays][:chef_overlay][:dir] = '/usr/local/portage/chef-overlay'
  default[:gentoo][:overlays][:chef_overlay][:rev] = '00e58aa07732cdd1fd656b67aa5b1c7b11ab0732'
  
else
  raise "This cookbook is Gentoo-only"
end
