
module Guard
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
