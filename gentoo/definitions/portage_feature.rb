#
# Usage::
#   Use this to enable portage FEATURES flags
# Examples:
#   portage_feature :buildpkg
#   portage_feature :nodocs do
#     flags %w( nodoc noinfo noman )
#   end
#
# Author:: Ho-Sheng Hsiao <hosh@sparkfly.com>
# Cookbook Name:: gentoo
# Definition:: portage_feature
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

define :portage_feature, :flags => nil do
  flags = params[:name] unless flags
  flags.join!(' ') if flags.is_a?(Array)

  log "Enabling FEATURES: #{flags}"

  portage_conf "feature_#{params[:name]}" do
    appends [ :FEATURES, flags ]
  end
end

