require 'guard'
require 'guard/guard'
require 'sprockets'

module Forge
  module Guard

    class << self
      attr_accessor :project
      attr_accessor :task
    end

    def self.add_guard(&block)
      @additional_guards ||= []
      @additional_guards << block
    end

    def self.start(project, task, options={}, livereload={})
      @project = project
      @task = task

      options_hash = ""
      options.each do |k,v|
        options_hash << ", :#{k} => '#{v}'"
      end

      guardfile_contents = %Q{
        guard 'forgeconfig'#{options_hash} do
          watch("config.yml")
        end
        guard 'forgeassets' do
          watch(%r{assets/javascripts/*})
          watch(%r{assets/stylesheets/*})
        end
      }

      (@additional_guards || []).each do |block|
        result = block.call(options, livereload)
        guardfile_contents << result unless result.nil?
      end

      ::Guard.start({ :guardfile_contents => guardfile_contents })
    end
  end
end

module Guard

  class ForgeConfig < Guard
    def initialize(watchers=[], options={})
      super
    end

    # Called on Ctrl-Z signal
    # This method should be mainly used for "reload" (really!) actions like reloading passenger/spork/bundler/...
    def reload
      puts "Reloading project config"
      ::Forge::Guard.project.load_config
    end

    # Called on Ctrl-\ signal
    # This method should be principally used for long action like running all specs/tests/...
    def run_all
      puts "Reloading project config"
      ::Forge::Guard.project.load_config
      true
    end

    # Called on file(s) modifications
    def run_on_change(paths)
      puts "Project config changed, reloading"
      ::Forge::Guard.project.load_config
    end
  end

  class ForgeAssets < Guard

    def initialize(watchers=[], options={})
      super
      @assets_path = File.join(::Forge::Guard.project.root, 'assets')
      init_sprockets
    end

    # Called on Ctrl-\ signal
    # This method should be principally used for long action like running all specs/tests/...
    def run_all
      p "Rebuilding all assets"
    end

    # Called on file(s) modifications
    def run_on_change(paths)
      p "Assets have changed, rebuilding..."
      rebuild
    end

    def cleanup
      # TODO: X-compatibility?
      ::Forge::Guard.task.run('rm -rf .forge/*')
    end

    def init_sprockets
      @sprockets = Sprockets::Environment.new

      ['javascripts', 'stylesheets'].each do |dir|
        @sprockets.append_path File.join(@assets_path, dir)
      end
    end

    def rebuild 
      [['style.css'], ['js', 'theme.js']].each do |asset|
        destination = File.join(::Forge::Guard.project.build_dir, asset)

        asset = @sprockets.find_asset(asset.last)

        asset.write_to(destination) unless asset.nil?
      end
    end
  end
end