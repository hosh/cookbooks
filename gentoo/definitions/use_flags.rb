#
# Usage::
#   Use this to add use flags for packages
#
#   use_flags :nginx do
#     package 'www-servers/nginx'
#     flags "static-gzip"
#   end
#
#   use_flags :nginx do
#     package 'www-servers/nginx'
#     flags %w(static-gzip pcre fcgi)
#   end
#
# Author:: Ho-Sheng Hsiao <hosh@sparkfly.com>
# Cookbook Name:: gentoo
# Definition:: use_flags
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

# This probably should be its own Resource/Provider set
define :use_flags, :package => nil, :flags => "" do
  raise "Must specify fully-qualified package name" unless params[:package]
  flags = params[:flags]
  flags = flags.join(' ') if flags.is_a?(Array)

  include_recipe('gentoo::portage')

  template "#{node[:gentoo][:package][:use]}/chef_#{params[:name]}" do
    owner "root"
    group "root"
    mode "0644"
    source "use_flags.erb"
    cookbook "gentoo" # Explicitly declared for portability
    variables(:package => params[:package], :flags => flags)
  end

end
