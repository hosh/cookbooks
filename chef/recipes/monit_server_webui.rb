# 
# Use this to monitor chef-server with monit
#
# Author:: Ho-Sheng Hsiao <hosh@sparkfly.com>
# Cookbook Name:: chef
# Recipe:: chef::monit_server_webui
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
  monit_http_service 'chef-server-webui' do
    process :listen_ips => [[nil, '4040']],
      :pid_file => '/var/run/chef/server-webui.4040.pid',
      :timout_before_restart => '30'
  end
end
