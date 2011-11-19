require 'pathname'
require 'compass'

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

    def initialize(root, task, config={}, config_file=nil)
      @root        = File.expand_path(root)
      @config      = config || {}
      @task        = task
      @config_file = config_file

      self.load_config if @config.empty?
    end

    def assets_path
      @assets_path ||= File.join(self.source_path, 'assets')
    end

    def build_path
      File.join(self.root, '.forge', 'build')
    end

    def source_path
      File.join(self.root, 'source')
    end

    def package_path
      File.join(self.root, 'package')
    end

    def templates_path
      File.join(self.source_path, 'templates')
    end

    def functions_path
      File.join(self.source_path, 'functions')
    end

    def includes_path
      File.join(self.source_path, 'includes')
    end

    def config_file
      @config_file ||= File.join(self.root, 'config.rb')
    end

    def global_config_file
      @global_config_file ||= File.join(ENV['HOME'], '.forge', 'config.rb')
    end

    # Create a symlink from source to the project build dir
    def link(source)
      source = File.expand_path(source)

      unless File.directory?(File.dirname(source))
        raise Forge::LinkSourceDirNotFound
      end

      @task.link_file build_path, source
    end

    def theme_id
      File.basename(self.root).gsub(/\W/, '_')
    end

    def load_config
      config = {}

      # Check for global (user) config.rb
      if File.exists?(self.global_config_file)
        config.merge!(load_ruby_config(self.global_config_file))
      end

      # Check for config.rb
      if File.exists?(self.config_file)
        config.merge!(load_ruby_config(self.config_file))
      else
        # Old format of config file
        if File.exists?(File.join(self.root, 'config.json'))
          config.merge!(convert_old_config)
        else
          raise Error, "Could not find the config file, are you sure you're in a
          forge project directory?"
        end
      end

      @config = config
    end

    def get_binding
      binding
    end

    def parse_erb(file)
      ERB.new(::File.binread(file), nil, '-', '@output_buffer').result(binding)
    end

    private

    def convert_old_config
      require 'json'

      # Let the user know what is going to happen
      @task.say("It looks like you are using the old JSON-format config. Forge will now try converting your config to the new Ruby format.")
      @task.ask(" Press any key to continue...")

      begin
        old_file_name = File.join(self.root, 'config.json')
        # Parse the old config format, convert keys to symbols
        @config = JSON.parse(File.open(old_file_name).read).inject({}){|memo,(k,v)| memo[k.to_sym] = v; memo}

        @task.create_file(@config_file) do
          # Find the config.tt template, and parse it using ERB
          config_template_path = @task.find_in_source_paths(File.join(['config', 'config.tt']))
          parse_erb(File.expand_path(config_template_path))
        end
      rescue Exception => e
        @task.say "Error while building new config file:", Thor::Shell::Color::RED
        @task.say e.message, Thor::Shell::Color::RED
        @task.say "You'll need to either fix the error and try again, or manually convert your config.json file to Ruby format (config.rb)"
        exit
      end

      @task.say "Success! Double-check that all your config values were moved over, and you can now delete config.json.", Thor::Shell::Color::GREEN

      # We now have a Ruby config file, so we can continue loading as normal
      return load_ruby_config(self.config_file)
    end

    def load_ruby_config(file)
      config = {}

      begin
        # Config file is just executed as straight ruby
        eval(File.read(file))
      rescue Exception => e
        @task.say "Error while evaluating config file:"
        @task.say e.message, Thor::Shell::Color::RED
      end

      return config
    end

  end
end
