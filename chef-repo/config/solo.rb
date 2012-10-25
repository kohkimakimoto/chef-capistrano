node_root_dir =  File.expand_path(File.dirname(__FILE__) + "/../..")


log_level :info
node_path nil
file_cache_path  "#{node_root_dir}/chef-cache"
file_backup_path "#{node_root_dir}/chef-backup"

cookbook_path ["#{node_root_dir}/chef-repo/cookbooks"]
role_path "#{node_root_dir}/chef-repo/roles"
