require 'guard'
require 'guard/guard'

module Guard
  class ForgeConfig < ::Guard::Guard
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
end
