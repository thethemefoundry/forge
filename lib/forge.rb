module Forge
  class << self
    attr_accessor :config
  end

  autoload :Guard, 'forge/guard'
  autoload :CLI, 'forge/cli'
end