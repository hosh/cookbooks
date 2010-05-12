# Taken from veszig-gentoo-sources
#
# Definitions::
#   monit -> generic monit service, supply your own template
#   monit_net_service -> monit a generic net service, including checking ports
#      monit_net_service :chef-solr do 
#        process :listen_ips => [['[::]', '8983']],
#          :pid_file => '/var/run/chef/solr.pid',
#          :timeout_before_restart => '60'
#      end
#
#   monit_http_service -> monit a generic http service, including checking ports for HTTP 
#      monit_http_service :chef-server do
#        process :listen_ips => [[nil, '4000']],
#          :pid_file => '/var/run/chef/server.4000.pid',
#          :timout_before_restart => '30'
#      end

define :monit, :enable => true, :source => nil, :cookbook => nil, :variables => {} do
  template_source =  params[:source] || "#{params[:name]}.monit.erb"
  template_cookbook = params[:cookbook]

  log "Fetching: cookbook = #{template_cookbook} / #{template_source}"
  
  template "/etc/monit.d/#{params[:name]}" do
    source template_source
    cookbook template_cookbook
    owner "root"
    group "root"
    mode "0600"
    variables params[:variables]
    notifies :reload, resources(:service => "monit")
    action params[:enable] ? :create : :delete
  end
end

define :monit_service, :enable => true, :source => 'service.monit.erb', :cookbook => 'monit', :process => {}, :variables => {} do
  process_info = params[:process] || {}
  
  # Set defaults
  process_info[:name] ||= params[:name]
  process_info[:pid_file] ||= "/var/run/#{process_info[:name]}.pid"
  process_info[:start_cmd] ||= "/etc/init.d/#{process_info[:name]} zap start"
  process_info[:stop_cmd] ||= "/etc/init.d/#{process_info[:name]} stop"

  template_variables = { :process => process_info }.merge(params[:variables])
  template_source = params[:source]
  template_cookbook = params[:cookbook]

  monit params[:name] do
    source template_source
    cookbook template_cookbook
    enable params[:enable]
    variables template_variables
  end
end

define :monit_net_service, :enable => true, :source => 'net_service.monit.erb', :cookbook => 'monit', :process => {}, :variables => {} do
  process_info = params[:process] || {}

  # Set defaults
  process_info[:listen_ips] ||= [ %w( 127.0.0.1 80) ]
  process_info[:timeout_before_restart] ||= '15'

  process_info[:listen_ips] = if process_info[:listen_ips].is_a?(Array)
    process_info[:listen_ips]
  else
    [ process_info[:listen_ips] ]
  end

  template_cookbook = params[:cookbook]
  template_source = params[:source]

  monit_service params[:name] do
    source template_source
    cookbook template_cookbook
    process process_info
    variables params[:variables] 
  end

end

define :monit_http_service, :enable => true, :source => nil, :cookbook => nil, :process => {}, :variables => {} do
  process_info = params[:process]
  process_info[:protocol] ||= 'http'

  monit_net_service params[:name] do
    source params[:source] if params[:source]
    cookbook params[:cookbook] if params[:cookbook]
    process process_info
    variables params[:variables]
    enable params[:enable]
  end
end
