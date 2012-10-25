module Chefistrano
  class ChefCookbookVersionLoader
    
    attr_reader :cookbook_name
    attr_reader :cookbook_settings
    attr_reader :metadata_filenames
    
    def initialize(path)
        @cookbook_path = File.expand_path( path )
        @cookbook_name = File.basename( path )
        @metadata = Hash.new
        @relative_path = /#{Regexp.escape(@cookbook_path)}\/(.+)$/
        @cookbook_settings = {
          :attribute_filenames  => {},
          :definition_filenames => {},
          :recipe_filenames     => {},
          :template_filenames   => {},
          :file_filenames       => {},
          :library_filenames    => {},
          :resource_filenames   => {},
          :provider_filenames   => {},
          :root_filenames       => {}
        }

        @metadata_filenames = []
    end
    
    
    def load_root_files
      Dir.glob(File.join(@cookbook_path, '*'), File::FNM_DOTMATCH).each do |file|
        next if File.directory?(file)
        @cookbook_settings[:root_filenames][file[@relative_path, 1]] = file
      end
    end
    
    def load_cookbooks
        load_as(:attribute_filenames, 'attributes', '*.rb')
        load_as(:definition_filenames, 'definitions', '*.rb')
        load_as(:recipe_filenames, 'recipes', '*.rb')
        load_as(:library_filenames, 'libraries', '*.rb')
        load_recursively_as(:template_filenames, "templates", "*")
        load_recursively_as(:file_filenames, "files", "*")
        load_recursively_as(:resource_filenames, "resources", "*.rb")
        load_recursively_as(:provider_filenames, "providers", "*.rb")
        load_root_files
        
        @cookbook_settings
    end

    def load_recursively_as(category, category_dir, glob)
      file_spec = File.join(@cookbook_path, category_dir, '**', glob)
      Dir.glob(file_spec, File::FNM_DOTMATCH).each do |file|
        next if File.directory?(file)
        @cookbook_settings[category][file[@relative_path, 1]] = file
      end
    end

    def load_as(category, *path_glob)
      Dir[File.join(@cookbook_path, *path_glob)].each do |file|
        @cookbook_settings[category][file[@relative_path, 1]] = file
      end
    end

  end
end
  
