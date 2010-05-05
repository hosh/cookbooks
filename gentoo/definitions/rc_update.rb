#
# Usage::
#   Use this to add services to runlevels
#   rc_update_add :rsyncd
#   rc_update_add 'net.eth0' do
#     runlevel :boot
#   end
#
# Author:: Ho-Sheng Hsiao <hosh@sparkfly.com>
# Cookbook Name:: gentoo
# Definition:: rc_update
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

# Pattern taken from: http://github.com/engineyard/ey-cloud-recipes/blob/master/cookbooks/ntp/recipes/default.rb
define :rc_update_add, :runlevel => 'default' do
  execute "add-#{params[:name]}-to-#{params[:runlevel]}" do
    command "rc-update add #{params[:name]} #{params[:runlevel]}"
    not_if "rc-status #{params[:runlevel]} | grep #{params[:name]}"
  end
end
