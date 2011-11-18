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
      UI.info "Reloading project config"
      ::Forge::Guard.project.load_config
    end

    # Called on Ctrl-\ signal
    # This method should be principally used for long action like running all specs/tests/...
    def run_all
      UI.info "Reloading project config"
      ::Forge::Guard.project.load_config
      true
    end

    # Called on file(s) modifications
    def run_on_change(paths)
      UI.info "Project config changed, reloading"
      ::Forge::Guard.project.load_config
      ::Forge::Guard.builder = ::Forge::Builder.new(::Forge::Guard.project)
      # Rebuild everything if the config changes
      ::Forge::Guard.builder.build
    end
  end
end
