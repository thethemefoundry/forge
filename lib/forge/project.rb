require 'pathname'
require 'json'

module Forge
  class Project
    class << self
      def create(root, config, task)
        root = File.expand_path(root)

        project = self.new(root, task, config)
        Generator.run(project)

        project
      end
    end

    attr_accessor :root, :config, :task

    def initialize(root, task, config={})
      @root        = File.expand_path(root)
      @config      = config || {}
      @task        = task

      self.load_config if @config.empty?
    end

    def assets_path
      @assets_path ||= File.join(self.root, 'assets')
    end

    def build_dir
      File.join(self.root, '.forge')
    end

    def config_file
      @config_file ||= File.join(self.root, 'config.json')
    end

    # Create a symlink from source to the project build dir
    def link(source)
      source = File.expand_path(source)

      unless File.directory?(File.dirname(source))
        raise Forge::LinkSourceDirNotFound
      end

      @task.link_file build_dir, source
    end

    def theme_id
      File.basename(self.root)
    end

    def load_config
      unless File.exists?(self.config_file)
        raise Error, "Could not find the config file, are you sure you're in a
        forge project directory?"
      end

      self.config = JSON.parse File.open(config_file).read
    end

    def get_binding
      binding
    end
  end
end
