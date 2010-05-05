#
# Following the instructions outlined at http://github.com/veszig/chef-overlay/blob/00e58aa07732cdd1fd656b67aa5b1c7b11ab0732/README.md
#
# Author:: Ho-Sheng Hsiao <hosh@sparkfly.com>
# Source:: http://www.gentoo-wiki.info/TIP_Exclude_categories_from_emerge_sync
# Cookbook Name:: gentoo
# Recipe:: chef_overlay
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

chef_overlay = node[:gentoo][:overlays][:chef_overlay]
git chef_overlay[:dir] do
  repository 'git://github.com/veszig/chef-overlay.git' 
  revision chef_overlay[:rev]
  action :sync
end

portage_conf :chef_overlay do
  appends [ 
    [ :ACCEPT_LICENSE, 'dlj-1.1' ],
    [ :COLLISION_IGNORE, '/usr/bin/prettify_json.rb', '/usr/bin/edit_json.rb'],
    [ :PORTDIR_OVERLAY, chef_overlay[:dir] ],
    [ :RUBY_TARGETS, 'ruby18' ]
  ]

end
