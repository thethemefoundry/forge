require 'guard'
require 'guard/guard'

module Guard
  class Forge < Guard

    def initialize(watchers=[], options={})
      super
    end

    # Called once when Guard starts
    # Please override initialize method to init stuff
    def start
      puts "Staring Forge previewer"
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
      puts "File Changed"
    end

  end
end