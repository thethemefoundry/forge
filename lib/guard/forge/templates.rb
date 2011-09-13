module Guard
  class ForgeTemplates < Guard
    def initialize(watchers=[], options={})
      super
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
