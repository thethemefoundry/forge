
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
      paths = [
        ['.forge'],
        ['assets', 'images'],
        ['assets', 'javascripts'],
        ['assets', 'stylesheets'],

        ['functions', 'inc'],

        ['templates', 'core'],
        ['templates', 'custom', 'pages'],
        ['templates', 'custom', 'partials']
      ]

      paths.each do |path|
        @task.empty_directory File.join(@project.root, path)
      end

      self
    end

    def copy_stylesheets
      source = [@layout, 'stylesheets', 'style.css.scss.erb']
      target = [@project.assets_path, 'stylesheets', 'style.css.scss']

      write_template(source, target)

      self
    end

    def copy_templates
      source = File.expand_path(File.join(self.layout_path, 'templates'))
      target = File.expand_path(File.join(@project.root, 'templates'))

      Dir.glob("#{source}/**/*") do |file|
        unless File.directory?(file)
          source_file = file.gsub(source, '')
          target_file = File.join(target, source_file)

          if source_file.end_with? ".erb"
            target_file = target_file.slice(0..-5)

            content = render_erb(file)
          else
            content = File.open(file).read
          end

          @task.create_file target_file do
            content
          end
        end
      end

      self
    end

    def copy_settings_library
      source = File.expand_path(@task.find_in_source_paths(File.join('lib', 'forge-settings')))
      target = File.expand_path(File.join(@project.root, 'functions', 'inc', 'forge-settings'))

      @task.directory(source, target)
    end

    def copy_functions
      source = File.expand_path(File.join(self.layout_path, 'functions', 'functions.php.erb'))
      target = File.expand_path(File.join(@project.root, 'functions', 'functions.php'))

      write_template(source, target)
    end

    def layout_path
      @layout_path ||= File.join(Forge::ROOT, 'layouts', @layout)
    end

    def run
      write_config
      create_structure
      copy_stylesheets
      copy_templates
      copy_functions
      copy_settings_library
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
        render_erb(template)
      end
    end

    protected
    def render_erb(file)
      ERB.new(::File.binread(file), nil, '-', '@output_buffer').result(@project.get_binding)
    end
  end
end
