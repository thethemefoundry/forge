require 'guard'
require 'guard/guard'

module Guard
  class ForgeTemplates < ::Guard::Guard
    def initialize(watchers=[], options={})
      super
    end

    def start
      ::Forge::Guard.builder.copy_templates
    end

    # Called on file(s) modifications
    def run_on_change(paths)
      ::Forge::Guard.builder.copy_templates
    end
  end
end
