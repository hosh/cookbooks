#
# Use this to add monit configuration to listen to nginx ports
# Automatically detects if monit is installed
#
# Cookbook Name:: nginx
# Definition:: monit_nginx
# Author:: Ho-Sheng Hsiao
# Taken from veszig-monit
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

define :monit_nginx, :listen => %w( 127.0.0.1 80 ), :cookbook => 'nginx'  do

  if node.recipe?("monit")
    monit_conf_name = "nginx.#{params[:name]}"

    listen = if params[:listen].first.is_a?(Array)
      params[:listen]
    else
      [ params[:listen] ]
    end

    # Bind variable locally
    # http://tickets.opscode.com/browse/CHEF-422
    use_cookbook = params[:cookbook]

    monit monit_conf_name  do
      cookbook use_cookbook
      source 'nginx.monit.erb'
      variables(:listen_ips => listen)
    end
  end

end
