#
# Cookbook Name:: rackspace
# Recipe:: hosts
#
# Copyright 2010, Sparkfly
# Modified from: http://blog.bitfluent.com/post/196658820/using-chef-server-indexes-as-a-simple-dns
# Copyright 2009, Bitfluent
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
#

global_hosts = {}
hosts        = {}

data_bag('cloud-hosts').each do |host|
  n = data_bag_item('cloud-hosts', host)
  global_hosts[n['ip']] = host
end

# NOTE: According to the 0.8 source code, there is a default row limit of 20. If the interface (via Couchdb) is what
# I think it is, then this will turn into a sleeping defect. We should be using djdns or PowerDNS by that point

# Structure:
# network
#   interfaces
#     eth1
#       addresses
#         locallink
#         ipv4 addr
#            addr
#            netmask
#            ...
#         ipv6 addr
search(:node, "network_interfaces_eth1_addresses:172.*") do |n|
  addresses = n['network']['interfaces']['eth1']['addresses'].map { |addr| addr[0] }
  ip = addresses.select { |addr| addr.to_s =~ /172.*/ }.first
  hosts[ip] = n
end

template "/etc/hosts" do
  source "hosts.erb"
  mode 0644
  variables(:global_hosts => global_hosts, :hosts => hosts)
end