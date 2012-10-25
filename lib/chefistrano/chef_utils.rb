module Chefistrano
  class ChefUtils

    def self.load_cookbooks(cookbooks_path)

      loaded_cookbooks = {}

      Dir[File.join(cookbooks_path, "*")].each do |cookbook_path|
        next unless File.directory?(cookbook_path)

        loader = Chefistrano::ChefCookbookVersionLoader.new(cookbook_path)
        loader.load_cookbooks

        loaded_cookbooks[loader.cookbook_name] = loader
      end

      loaded_cookbooks
    end

    def self.generate_run_list_file_path(base_dir)
      timestamp = Time.now.strftime("%Y%m%d%H%M%S")
      "#{base_dir}/run_list_#{timestamp}.json"
    end

    def self.generate_run_list_json(chef_run_list)

      run_list = { 'run_list' => [] }

      # Set up run_list
      chef_run_list.each do |v|
        run_list['run_list'].push(v)
      end

      JSON.generate(run_list)
    end

  end


end



