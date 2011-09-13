require 'guard'
require 'guard/guard'

module Forge
  module Guard
    def self.add_guard(&block)
      @additional_guards ||= []
      @additional_guards << block
    end

    def self.start(options={}, livereload={})
      options_hash = ""
      options.each do |k,v|
        options_hash << ", :#{k} => '#{v}'"
      end

      guardfile_contents = %Q{
        guard 'forgeconfig'#{options_hash} do
          watch("config.yml")
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

    # Called once when Guard starts
    # Please override initialize method to init stuff
    def start
      puts "Starting Forge config watcher"
    end

    # Called on Ctrl-C signal (when Guard quits)
    def stop
      puts "Stopping Forge config watcher"
    end

    # Called on Ctrl-Z signal
    # This method should be mainly used for "reload" (really!) actions like reloading passenger/spork/bundler/...
    def reload
      true
    end

    # Called on Ctrl-\ signal
    # This method should be principally used for long action like running all specs/tests/...
    def run_all
      true
    end

    # Called on file(s) modifications
    def run_on_change(paths)
      puts "Config Changed"
      p paths
    end
  end

  class Forge < Guard

    def initialize(watchers=[], options={})
      super
    end

    # Called once when Guard starts
    # Please override initialize method to init stuff
    def start
      puts "Starting Forge previewer"
    end

    # Called on Ctrl-C signal (when Guard quits)
    def stop
      puts "Stopping Forge previewer"
    end

    # Called on Ctrl-Z signal
    # This method should be mainly used for "reload" (really!) actions like reloading passenger/spork/bundler/...
    def reload
      true
    end

    # Called on Ctrl-\ signal
    # This method should be principally used for long action like running all specs/tests/...
    def run_all
      true
    end

    # Called on file(s) modifications
    def run_on_change(paths)
      template_paths.each do |template_path|
        FileUtils.cp_r template_path, '.forge'
      end
    end

    private

    def template_paths
      paths = [
        ['templates', 'core', '.'],
        ['templates', 'custom', 'pages', '.'],
        ['templates', 'custom', 'partials', '.']
      ]

      paths.collect { |path| File.join(path) }
    end

  end
end