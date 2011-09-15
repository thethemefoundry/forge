require 'forge/error'

module Forge
  ROOT = File.expand_path(File.join(File.dirname(__FILE__), '..'))
  autoload :Guard, 'forge/guard'
  autoload :CLI, 'forge/cli'
  autoload :Project, 'forge/project'
  autoload :Builder, 'forge/builder'
  autoload :Generator, 'forge/generator'
  autoload :Config, 'forge/config'
end