require 'guard'
require 'guard/guard'

module Guard
  class ForgeAssets < ::Guard::Guard

    def initialize(watchers=[], options={})
      super
    end

    def start
      UI.info "Building all assets"
      ::Forge::Guard.builder.build_assets
    end

    # Called on Ctrl-\ signal
    # This method should be principally used for long action like running all specs/tests/...
    def run_all
      UI.info "Rebuilding all assets"
      ::Forge::Guard.builder.clean_images
      ::Forge::Guard.builder.build_assets
    end

    # Called on file(s) modifications
    def run_on_change(paths)
      UI.info "Assets have changed, rebuilding..."
      ::Forge::Guard.builder.clean_images
      ::Forge::Guard.builder.build_assets
    end
  end
end
