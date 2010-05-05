#
# Usage::
#   Use this to define anything you want sourced into /etc/make.conf
#
# Author:: Ho-Sheng Hsiao <hosh@sparkfly.com>
# Cookbook Name:: gentoo
# Definition:: portage_conf
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


# Overrides examples:
#   portage_conf :rsync_excludes do
#     overrides => [ :PORTAGE_RSYNC_EXTRA_OPTS, '/etc/portage/chef/rsync_excludes', '/tmp/other_excludes' ]
#   end
#
#   portage_conf :rackspace do
#     overrides [
#       [ :PORTAGE_RSYNC_EXTRA_OPTS, '/etc/portage/chef/rsync_excludes', '/tmp/other_excludes' ],
#       [ :GENTOO_MIRRORS, 'http://mirror.datapipe.net/gentoo', 'http://gentoo.cites.uiuc.edu/pub/gentoo/' ],
#       [ :PORTAGE_NICENESS, '19' ]
#     ]
#   end
#
# Appends examples:
#   portage_conf :java do
#     appends [ :USE, 'java', 'ssl' ]
#   end
#
#   portage_conf :chef_overlay do
#     appends [
#       [ :ACCEPT_LICENSE, 'dlj-1.1'], 
#       [ :PORTDIR_OVERLAY, '/usr/local/portage/chef-overlay' ],
#       [ :COLLISION_IGNORE, '/usr/bin/prettify_json.rb', '/usr/bin/edit_json.rb'],
#     ] 
#     overrides [ :RUBY_TARGETS, 'ruby18' ]
#   end
#
# Sources example:
#   portage_conf :overlays do
#     sources %w( /usr/local/portage/layman/make.conf /usr/local/portage/site/make.conf )
#   end
#
# This definition generates a conf file that is sourced by /etc/portage/chef/make.conf
# This is intended to allow a mix of recipes, such as rsync_exclude, layman, site_rsync_mirror, binary_repository, etc.
# such that they get included in the make.conf which portage uses to emerge packages.

define :portage_conf, :appends => [], :overrides => [], :sources => [] do
  include_recipe 'gentoo::portage'

  def map_override(list)
    env_var = list.shift
    [env_var, list.join(' ')]
  end

  def map_append(list)
    env_var, override = map_override(list)
    [env_var, "${#{env_var.to_s}} #{override}"]
  end

  def map_conf(conf_param, &block)
    if params[conf_param].any? && params[conf_param].first.is_a?(Symbol) then
      [ block.call(params[conf_param]) ]
    else
      params[conf_param].map { |element| block.call(element) }
    end
  end

  # Normalize overrides, appends, and sources for output
  overrides = map_conf(:overrides) { |e| map_override(e) }
  appends   = map_conf(:appends) { |e| map_append(e) }
  sources   = params[:sources].uniq

  extra_portage_conf = "#{node[:gentoo][:extra_portage_conf_dir]}/#{params[:name]}"

  template extra_portage_conf do
    owner 'root'
    group 'root'
    mode '0755'
    source 'extra_portage_conf.erb'
    variables(:overrides => overrides, :appends => appends, :sources => sources)
  end

  # http://gist.github.com/382024
  # Append conf file  directly into the conf

  chef_make_conf = resources(:template => node[:gentoo][:extra_portage_conf])

  # Wait until later to add the variables in. This makes changes to make.conf
  # atomically valid, otherwise emerge will barf.
  ruby_block do 
    block do
      chef_make_conf.variables[:sources] << params[:name]
      chef_make_conf.run_action(:create)
    end
  end
end
