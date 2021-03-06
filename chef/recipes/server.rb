#
# Author:: Joshua Timberman <joshua@opscode.com>
# Author:: Joshua Sierles <joshua@37signals.com>
# Cookbook Name:: chef
# Recipe:: server
#
# Copyright 2008-2009, Opscode, Inc
# Copyright 2009, 37signals
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

root_group = value_for_platform(
  "openbsd" => { "default" => "wheel" },
  "freebsd" => { "default" => "wheel" },
  "default" => "root"
)

include_recipe "chef::client"

%w{chef-solr chef-solr-indexer chef-server}.each do |svc|
  service svc do
    action :nothing
  end
  if node.recipe?('monit')
    case node.platform
    when 'gentoo'
      template "/etc/init.d/#{svc}" do
        source "init.d/#{svc}.erb"
        owner 'root'
        group 'root'
        mode '0755'
      end

    else
      Chef::Log.warn "Monit may not play nice with chained services #{svc}" 
    end
  end

end

if node[:chef][:webui_enabled]
  service "chef-server-webui" do
    action :nothing
  end
end

if node[:chef][:server_log] == "STDOUT"
  server_log = node[:chef][:server_log]
  show_time  = "false"
else
  server_log = "\"#{node[:chef][:server_log]}\""
  show_time  = "true"
end

# Create empty amqp pass file
file node[:chef][:amqp_pass_file] do
  action :touch
  not_if "test -f #{node[:chef][:amqp_pass_file]}"
end

template "/etc/chef/solr.rb" do
  source "solr.rb.erb"
  owner 'root'
  group root_group
  mode '0644'
end

template "/etc/chef/server.rb" do
  source "server.rb.erb"
  owner "root"
  group root_group
  mode "644"
  variables(
    :server_log => server_log,
    :show_time  => show_time
  )
  if node[:chef][:webui_enabled]
    notifies :restart, resources( :service => "chef-solr", :service => "chef-solr-indexer", :service => "chef-server", :service => "chef-server-webui"), :delayed
  else
    notifies :restart, resources( :service => "chef-solr", :service => "chef-solr-indexer", :service => "chef-server"), :delayed
  end
end

http_request "compact chef couchDB" do
  action :post
  url "#{Chef::Config[:couchdb_url]}/chef/_compact"
  only_if do
    begin
      open("#{Chef::Config[:couchdb_url]}/chef")
      JSON::parse(open("#{Chef::Config[:couchdb_url]}/chef").read)["disk_size"] > 100_000_000
    rescue OpenURI::HTTPError
      nil
    end
  end
end

%w(nodes roles registrations clients data_bags data_bag_items users).each do |view|
  http_request "compact chef couchDB view #{view}" do
    action :post
    url "#{Chef::Config[:couchdb_url]}/chef/_compact/#{view}"
    only_if do
      begin
        open("#{Chef::Config[:couchdb_url]}/chef/_design/#{view}/_info")
        JSON::parse(open("#{Chef::Config[:couchdb_url]}/chef/_design/#{view}/_info").read)["view_index"]["disk_size"] > 100_000_000
      rescue OpenURI::HTTPError
        nil
      end
    end
  end
end
