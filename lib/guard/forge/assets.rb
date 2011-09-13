require 'guard'
require 'guard/guard'

module Guard
  class ForgeAssets < ::Guard::Guard

    def initialize(watchers=[], options={})
      super
    end

    def start
      ::Forge::Guard.builder.build_assets
    end

    # Called on Ctrl-\ signal
    # This method should be principally used for long action like running all specs/tests/...
    def run_all
      p "Rebuilding all assets"
      ::Forge::Guard.builder.build_assets
    end

    # Called on file(s) modifications
    def run_on_change(paths)
      p "Assets have changed, rebuilding..."
      ::Forge::Guard.builder.build_assets
    end
  end
end
