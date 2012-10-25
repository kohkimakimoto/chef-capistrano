require 'json'

namespace :chef do


  #############################################################################################
  # Defines dynamic capistrano tasks
  # Run chef-solo on the server.
  #
  # Syntax.
  #   chef:[chef-rolename]
  # Exsample
  #   chef:web  -- This is to run chef-solo using chef role "web".
  #############################################################################################
  # loaded_cookbooks = Chefistrano::ChefUtils.load_cookbooks("#{chefistrano_root_dir}/chef-repo/cookbooks")
  if !chef_roles.nil? then
    chef_roles.each do |rolename, role|
      # defaults task in role
      desc "Run chef-solo on the [#{rolename}] role node"
      task rolename, :roles => ("chef_auto_role_" + rolename.to_s).to_sym do

        # Syncronize chefistrano node directory that includes "chef repository(coockbook and etc...)".
        run "sudo mkdir -p #{chefistrano_node_root_dir}"
        run "sudo chown -R #{user}:#{user} #{chefistrano_node_root_dir}"

        find_servers_for_task(current_task).each do |server|

          portopt = ""
          if server.port
            portopt =  " -p #{server.port}"
          end

          logger.trace "rsync -avzC --delete --progress -e \"ssh#{portopt}\" #{chefistrano_root_dir}/chef-repo #{user}@#{server.host}:#{chefistrano_node_root_dir}/"
          `rsync -avzC --delete --progress -e \"ssh#{portopt}\" #{chefistrano_root_dir}/chef-repo #{user}@#{server.host}:#{chefistrano_node_root_dir}/`

        end

        # Setup chef run-list json file path
        run_list_file = Chefistrano::ChefUtils.generate_run_list_file_path(chefistrano_node_root_dir)

        # Create run_list json file.at target node.
        run "echo '{\"run_list\":[\"role[#{rolename}]\"]}' > #{run_list_file}"
        # Execute chef-solo
        run "#{sudo_command} chef-solo -c #{chefistrano_node_root_dir}/chef-repo/config/solo.rb -j #{run_list_file}"
        run "rm #{run_list_file}"

      end

    end
  end

  #############################################################################################
  # Defines dynamic capistrano tasks
  #############################################################################################
  if !chef_role_suits.nil? then

    chef_role_suits.each do |suit, roles|

      desc "Run chef-solo on the nodes associated roles #{roles.to_s}"
      task suit.to_s do

        logger.trace "This task executes chef-solo #{roles.to_s}"

        # TODO: Executes in parallel. Current implimentation is seriall.
        roles.each do |role|

          eval(role.to_s)

        end

      end

    end

  end

end

