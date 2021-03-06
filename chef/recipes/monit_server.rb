# 
# Use this to monitor chef-server with monit
#
# Author:: Ho-Sheng Hsiao <hosh@sparkfly.com>
# Cookbook Name:: chef
# Recipe:: chef::monit_server
#
# Copyright 2010 Sparkfly
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

if node.recipe?('monit')
  # Chef server requires authorization, so monit http protocol check fails
  # Use monit_net_service instead for generic net monitoring
  monit_net_service 'chef-server' do
    process :listen_ips => [[nil, '4000']],
      :pid_file => '/var/run/chef/server.4000.pid',
      :timout_before_restart => '30'
  end
end
