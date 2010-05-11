#
# Use this to enable binpkg_respect_use on every emerge
#
# When this is enabled, Portage will check USE flags in binary packages before
# using it. If the binary package does not match, portage will ignore the binary
# package
#
# Author:: Ho-Sheng Hsiao <hosh@sparkfly.com>
# Source:: http://www.gentoo.org/doc/en/rsync.xml#doc_chap2
# Cookbook Name:: gentoo
# Recipe:: portage_binpkg_respect_use
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


log "Enabling Portage Options: --binpkg-respect-use y"

portage_conf :portage_rsync do
  appends [ :EMERGE_DEFAULT_OPTS, '--binpkg-respect-use y' ]
end
