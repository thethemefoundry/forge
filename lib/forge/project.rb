require 'pathname'

module Forge
  class Project
    class << self
      def create(root, config, task)
        root = File.expand_path(root)

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
          task.empty_directory File.join(root, path)
        end

        project = self.new(root, task, config)
        project.write_config
        project.write_stylesheet
        project.copy_default_templates
        project
      end
    end

    attr_reader :config_file
    attr_accessor :root, :config, :task

    def initialize(root, task, config={})
      @root    = File.expand_path(root)
      @config  = config || {}
      @config_file = File.join(root, 'config.yml')
      @task        = task

      load_config if @config.empty?
    end

    def build_dir
      File.join(root, '.forge')
    end

    def name
      File.basename(root)
    end

    def load_config
      unless File.exists?(@config_file)
        raise Error, "Could not find the config file, are you sure you're in a
        forge project directory?"
      end

      self.config = YAML.load(@config_file)
    end

    def write_config
      write_template(['config', 'config.yml.erb'], @config_file)

      self
    end

    def write_stylesheet
      write_template(['stylesheets', 'style.css.scss.erb'], [root, 'assets', 'stylesheets', 'style.css.scss'])

      self
    end

    def copy_default_templates
      template_path = File.join('templates', 'core')
      output_path = File.join(@root, 'templates', 'core')

      @task.directory(template_path, output_path)

      self
    end

    protected
    def write_template(source, target)
      source   = File.join(source)
      template = File.expand_path(@task.find_in_source_paths((source)))
      target   = File.expand_path(File.join(target))

      @task.create_file target do
        ERB.new(::File.binread(template), nil, '-', '@output_buffer').result(binding)
      end
    end
  end
end
