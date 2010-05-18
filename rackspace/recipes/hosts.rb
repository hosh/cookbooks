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

ghetto_dns = node[:ghetto_dns][:hosts]

# Ohai manages :rackspace, if you are on rackspace.
private_ip = if node[:cloud] && node[:cloud][:provider] == 'rackspace'
  Chef::Log.info("Rackspace Cloud Server detected")
  node[:rackspace][:private_ip]
else 
  Chef::Log.info("Rackspace Cloud Server not detected. Emulating private_ip device")

  # Determine private ip address
  private_addresses =  node[:network][:interfaces][ghetto_dns[:private_eth]][:addresses].map { |addr| addr[0] }
  private_ip = private_addresses.select { |addr| addr.to_s =~ /#{ghetto_dns[:private_net]}/ }.first

  Chef::Log.info("Detected private_ip: #{private_ip} ( #{private_addresses.inspect} )")

  # Report back to Server Index. Note this is executed at compile-time
  unless node[:rackspace][:private_ip] == private_ip  
    node[:rackspace][:private_ip] = private_ip 
    Chef::Log.info("New private_ip detected, pushing back to server index.")
    node.save
  end

  private_ip
end

def private_aliases_from(n)
  ((n[:ghetto_dns] && n[:ghetto_dns][:private_aliases]) || []).sort
end

def private_host(n)
  [ n[:fqdn] ] + private_aliases_from(n)
end

search(:node, "rackspace_private_ip:#{ghetto_dns[:private_net]}" ) do |n|
  ip = n[:rackspace][:private_ip]
  hosts[ip] = private_host(n)
end

Chef::Log.debug("Host file: #{hosts.inspect}")

# If the server index has not caught up yet, add this so we can at 
# least reference ourselves
hosts[private_ip] = private_host(node) unless hosts[private_ip]

Chef::Log.info("Host file: #{hosts.inspect}")

template "/etc/hosts" do
  source "hosts.erb"
  mode 0644
  variables(:global_hosts => global_hosts, :hosts => hosts)
end
