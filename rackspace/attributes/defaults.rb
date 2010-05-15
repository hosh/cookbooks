# Rackspace Hosts

set[:rackspace][:hosts][:private_eth] = 'eth1'
set[:rackspace][:hosts][:private_net] = '10.*'

# If you are using something like VMWare Fusion, you can use this instead
# Set this on your site-cookbooks or role overrides
#set[:rackspace][:hosts][:private_net] = '172.*'

# Set this to add aliases in addition to the canonical name.
default[:rackspace][:hosts][:private_aliases] = []

# Examples:
# default[:rackspace][:hosts][:private_aliases] = %w( chef-server portage-server nagios )

