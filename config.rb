###############################################################################
# User Configurations.
#
# Set users used by ssh.
# user requirement:
#   To run sudo.
#   To Authenticate public key and NOPASSWD
###############################################################################
set :user, 'username'

###############################################################################
# Environment Configurations
###############################################################################
set :chefistrano_root_dir,      File.expand_path(File.dirname(__FILE__))
set :chefistrano_node_root_dir, '/tmp/chefistrano-node'

set :sudo_command, 'rvmsudo'

###############################################################################
# Managed Servers Configurations
###############################################################################
chef_role :local,  "127.0.0.1:22"    # This is to execute chef-solo using chef's role "local" on the server 127.0.0.1.

#chef_role_suit :all,
#  :local, :somerole



