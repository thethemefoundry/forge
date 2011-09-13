require 'guard'
require 'guard/guard'

module Guard
  class ForgeTemplates < ::Guard::Guard
    def initialize(watchers=[], options={})
      super

      root = ::Forge::Guard.project.root

      @templates_path = File.join(root, 'templates')
    end

    def start
      copy_templates
    end

    # Called on file(s) modifications
    def run_on_change(paths)
      copy_templates
    end

    private

    def copy_templates
      template_paths.each do |template_path|
        FileUtils.cp_r template_path, '.forge'
      end
    end

    def template_paths
      @template_paths ||= [
        ['core', '.'],
        ['custom', 'pages', '.'],
        ['custom', 'partials', '.']
      ].collect { |path| File.join(@templates_path, path) }
    end
  end
end
