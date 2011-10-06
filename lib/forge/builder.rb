require 'sprockets'
require 'sprockets-sass'
require 'sass'
require 'zip/zip'
require 'compass'

module Forge
  class Builder
    def initialize(project)
      @project = project
      @task    = project.task
      @templates_path = @project.templates_path
      @assets_path = @project.assets_path
      @functions_path = @project.functions_path
      @includes_path = @project.includes_path

      init_sprockets
    end

    # Runs all the methods necessary to build a completed project
    def build
      clean_build_directory
      copy_templates
      copy_functions
      build_assets
    end

    # Use the rubyzip library to build a zip from the generated source
    def zip
      basename = File.basename(@project.root)

      Zip::ZipFile.open(get_output_filename(basename), Zip::ZipFile::CREATE) do |zip|
        # Get all filenames in the build directory recursively
        filenames = Dir[File.join(@project.build_path, '**', '*')]

        # Remove the build directory path from the filename
        filenames.collect! {|path| path.gsub(/#{@project.build_path}\//, '')}

        # Add each file in the build directory to the zip file
        filenames.each do |filename|
          zip.add File.join(basename, filename), File.join(@project.build_path, filename)
        end
      end
    end

    # Empty out the build directory
    def clean_build_directory
      FileUtils.rm_rf Dir.glob(File.join(@project.build_path, '*'))
    end

    def clean_templates
      # TODO: cleaner way of removing templates only?
      Dir.glob(File.join(@project.build_path, '*.php')).each do |path|
        FileUtils.rm path unless path.include?('functions.php')
      end
    end

    def copy_templates
      template_paths.each do |template_path|
        FileUtils.cp template_path, @project.build_path unless File.directory?(template_path)
      end
    end

    def copy_functions
      FileUtils.cp_r File.join(@functions_path, 'functions.php'), @project.build_path
    end

    def clean_includes
      FileUtils.rm_rf File.join(@project.build_path, 'includes')
    end

    def copy_includes
      unless Dir.glob(File.join(@includes_path, '*')).empty?
        FileUtils.cp_r @includes_path, @project.build_path
      end
    end

    def clean_images
      FileUtils.rm_rf File.join(@project.build_path, 'images')
    end

    def build_assets
      [['style.css'], ['js', 'theme.js']].each do |asset|
        destination = File.join(@project.build_path, asset)

        sprocket = @sprockets.find_asset(asset.last)

        sprockets_error = false

        # Catch any sprockets errors and continue the process
        begin
          @task.shell.mute do
            FileUtils.mkdir_p(File.dirname(destination)) unless File.directory?(File.dirname(destination))
            sprocket.write_to(destination) unless sprocket.nil?

            if asset.last == 'style.css' && (not sprockets_error)
              @task.prepend_file destination, @project.parse_erb(stylesheet_header)
            end
          end
        rescue Exception => e
          @task.say "Error while building #{asset.last}:"
          @task.say e.message, Thor::Shell::Color::RED
          File.open(destination, 'w') do |file|
            file.puts(e.message)
          end

          # Re-initializing sprockets to prevent further errors
          # TODO: This is done for lack of a better solution
          init_sprockets
        end
      end

      # Copy the images directory over
      FileUtils.cp_r File.join(@assets_path, 'images'), File.join(@project.build_path)
    end

    private

    def init_sprockets
      Compass.configuration do |compass|
        compass.line_comments = false
      end

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
      Dir.glob(File.join(@templates_path, '**', '*'))
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
