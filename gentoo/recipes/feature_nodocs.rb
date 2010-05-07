#
# Use this if you want docs, man pages, and info pages
#
# Author:: Ho-Sheng Hsiao <hosh@sparkfly.com>
# Source:: http://www.gentoo.org/doc/en/handbook/handbook-x86.xml?part=2&chap=3#doc_chap4 
# Cookbook Name:: gentoo
# Recipe:: feature_nodocs
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

portage_feature :nodocs do
  flags %w( nodoc noinfo noman )
end
