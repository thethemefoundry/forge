
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

        ['functions'],

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
      source = [self.layout_path, 'stylesheets', 'style.css.scss.erb']
      target = [@project.assets_path, 'stylesheets', 'style.css.scss']

      write_template(source, target)

      self
    end

    def copy_templates
      source = File.join(self.layout_path, 'templates')
      target = File.join(@project.root, 'templates')

      @task.directory(source, target)

      self
    end

    def layout_path
      @layout_path ||= File.join(@layout)
    end

    def run
      write_config
      create_structure
      copy_stylesheets
      copy_templates
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
        ERB.new(::File.binread(template), nil, '-', '@output_buffer').
          result(@project.get_binding)
      end
    end
  end
end
