
module Forge
  class Generator
    class << self
      def run(project, layout='default')
        generator = self.new(project, layout)
        generator.run
      end
    end

    def initialize(project, layout='default')
      @project = project
      @task    = project.task
      @layout  = layout
    end

    def create_structure
      # Create the build directory for Forge output
      @task.empty_directory @project.build_path

      source_paths = [
        ['assets', 'images'],
        ['assets', 'javascripts'],
        ['assets', 'stylesheets'],

        ['framework'],

        ['functions'],

        ['includes'],

        ['templates', 'pages'],
        ['templates', 'partials'],
      ]

      # Build out Forge structure in the source directory
      source_paths.each do |path|
        @task.empty_directory File.join(@project.source_path, path)
      end

      self
    end

    def copy_stylesheets
      source = File.expand_path(File.join(self.layout_path, 'stylesheets'))
      target = File.expand_path(File.join(@project.assets_path, 'stylesheets'))

      render_directory(source, target)

      self
    end

    def copy_javascript
      source = File.expand_path(File.join(self.layout_path, 'javascripts'))
      target = File.expand_path(File.join(@project.assets_path, 'javascripts'))

      render_directory(source, target)

      self
    end

    def copy_templates
      source = File.expand_path(File.join(self.layout_path, 'templates'))
      target = File.expand_path(File.join(@project.source_path, 'templates'))

      render_directory(source, target)

      self
    end

    def copy_settings_library
      settings_path = @task.find_in_source_paths(File.join('lib', 'struts', 'classes'))

      source = File.expand_path(settings_path)
      target = File.expand_path(File.join(@project.includes_path, 'struts', '.'))

      @task.directory(source, target)
    end

    def copy_functions
      source = File.expand_path(File.join(self.layout_path, 'functions', 'functions.php.erb'))
      target = File.expand_path(File.join(@project.source_path, 'functions', 'functions.php'))

      write_template(source, target)
    end

    def layout_path
      @layout_path ||= File.join(Forge::ROOT, 'layouts', @layout)
    end

    def run
      write_config
      create_structure
      copy_stylesheets
      copy_javascript
      copy_templates
      copy_functions
      copy_settings_library if @task.options[:struts]
      return self
    end

    def write_config
      write_template(['config', 'config.json.erb'], @project.config_file)

      self
    end

    def write_template(source, target)
      source   = File.join(source)
      template = File.expand_path(@task.find_in_source_paths((source)))
      target   = File.expand_path(File.join(target))

      @task.create_file target do
        @project.parse_erb(template)
      end
    end

    protected
    def render_directory(source, target)
      Dir.glob("#{source}/**/*") do |file|
        unless File.directory?(file)
          source_file = file.gsub(source, '')
          target_file = File.join(target, source_file)

          if source_file.end_with? ".erb"
            target_file = target_file.slice(0..-5)

            content = @project.parse_erb(file)
          else
            content = File.open(file).read
          end

          @task.create_file target_file do
            content
          end
        end
      end
    end
  end
end
