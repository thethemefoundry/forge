require 'guard'
require 'guard/guard'

module Guard
  class ForgeTemplates < ::Guard::Guard
    def initialize(watchers=[], options={})
      super
    end

    def start
      UI.info "Copying templates over"
      ::Forge::Guard.builder.copy_templates
    end

    # Called on file(s) modifications
    def run_on_change(paths)
      UI.info "Templates have changed, copying over"
      ::Forge::Guard.builder.copy_templates
    end
  end
end
