require 'guard'
require 'guard/guard'

module Guard
  class ForgeFunctions < ::Guard::Guard
    def initialize(watchers=[], options={})
      super
    end

    def start
      UI.info "Copying functions over"
      ::Forge::Guard.builder.copy_functions
      ::Forge::Guard.builder.copy_includes
    end

    def run_all
      UI.info "Rebuilding all functions"
      ::Forge::Guard.builder.clean_functions
      ::Forge::Guard.builder.copy_functions
      ::Forge::Guard.builder.clean_includes
      ::Forge::Guard.builder.copy_includes
    end

    # Called on file(s) modifications
    def run_on_change(paths)
      UI.info "Functions have changed, copying over"
      ::Forge::Guard.builder.clean_functions
      ::Forge::Guard.builder.copy_functions
      ::Forge::Guard.builder.clean_includes
      ::Forge::Guard.builder.copy_includes
    end
  end
end
