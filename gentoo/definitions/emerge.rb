#
# Usage::
#   Use this to install Gentoo-specific packages
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

define :emerge, :action => :install, :check_corruption => true do
  include_recipe 'gentoo::gentoolkit'

  def test?(query, opts = '')
    "test #{opts} \"`#{query}`\""
  end

  def installed?(pkg)
    test?("equery -q list -e #{pkg}")
  end

  def not_corrupted?(pkg)
    test?("qcheck -q -B -e #{pkg}", '-z')
  end

  def check(*args)
    args.join(' && ')
  end

  # It is weird, but we cannot call the above functions directly, so instead
  # we call them here and bind them to variables accessible from the block
  has_good_package = if params[:check_corruption]

    # Make sure we have qcheck available
    has_portage_utils = check(installed?('portage-utils'), not_corrupted?('portage-utils'))
    portage_package 'portage-utils' do
      action :install
      not_if has_portage_utils
    end

    check(installed?(params[:name]), not_corrupted?(params[:name]))
  else
    check(installed?(params[:name]))
  end

  portage_package params[:name] do
    action :install 
    not_if has_good_package
  end
end

# This might be better implemented as a full Resource/Provider
define :emerge_sync do
  execute "emerge_sync" do
    command "emerge --sync"
  end

  portage_package "portage" do
    action :upgrade
    options "--update" # Portage provider does not properly implement upgrade action
  end
end
