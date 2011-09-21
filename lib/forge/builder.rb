require 'sprockets'
require 'sass'
require 'zip/zip'

module Forge
  class Builder
    def initialize(project)
      @project = project
      @task    = project.task
      @templates_path = File.join(@project.root, 'templates')
      @assets_path = File.join(@project.root, 'assets')

      init_sprockets
    end

    # Runs all the methods necessary to build a completed project
    def build
      copy_templates
      copy_functions
      build_assets
    end

    # Use the rubyzip library to build a zip from the generated source
    def zip
      basename = File.basename(@project.root)

      Zip::ZipFile.open(get_output_filename(basename), Zip::ZipFile::CREATE) do |zip|
        # Get all filenames in the build directory recursively
        filenames = Dir[File.join(@project.build_dir, '**', '*')]

        # Remove the build directory path from the filename
        filenames.collect! {|path| path.gsub(/#{@project.build_dir}\//, '')}

        # Add each file in the build directory to the zip file
        filenames.each do |filename|
          zip.add File.join(basename, filename), File.join(@project.build_dir, filename)
        end
      end
    end

    def copy_templates
      template_paths.each do |template_path|
        FileUtils.cp_r template_path, @project.build_dir
      end
    end

    def copy_functions
      functions_path = File.join(@project.root, 'functions', '.')
      FileUtils.cp_r functions_path, @project.build_dir
    end

    def build_assets
      [['style.css'], ['js', 'theme.js']].each do |asset|
        destination = File.join(@project.build_dir, asset)

        sprocket = @sprockets.find_asset(asset.last)

        sprocket.write_to(destination) unless sprocket.nil?

        if asset.last == 'style.css'
          @task.prepend_file destination, @project.parse_erb(stylesheet_header)
        end
      end
    end

    private

    def init_sprockets
      @sprockets = Sprockets::Environment.new

      ['javascripts', 'stylesheets'].each do |dir|
        @sprockets.append_path File.join(@assets_path, dir)
      end

      @sprockets.context_class.instance_eval do
        def config
          return {:name => 'asd'}
          p "CALLING CONFIG"
          @project.config
        end
      end
    end

    def template_paths
      @template_paths ||= [
        ['core', '.'],
        ['custom', 'pages', '.'],
        ['custom', 'partials', '.']
      ].collect { |path| File.join(@templates_path, path) }
    end

    # Generate a unique filename for the zip output
    def get_output_filename(basename)
      filename = "#{basename}.zip"

      i = 1
      while File.exists?(filename)
        filename = "#{basename}(#{i}).zip"
        i += 1
      end

      filename
    end

    protected
    def stylesheet_header
      return @stylesheet_header unless @stylesheet_header.nil?

      file = @task.find_in_source_paths(File.join('config', 'stylesheet_header.erb'))
      @stylesheet_header = File.expand_path(file)
    end
  end
end