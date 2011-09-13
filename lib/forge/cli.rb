require 'thor'
require 'yaml'

module Forge
  class CLI < Thor
    include Thor::Actions

    def self.source_root
      File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'templates'))
    end

    desc "init dir", "Initializes a Forge project"
    def init(dir)
      config = {
        :name       => ask("What is the name of this theme?"),
        :uri        => ask("What is the website for the theme?"),
        :author     => ask("What is the author's name?"),
        :author_url => ask("What is the author's url?")
      }

      project = Forge::Project.create(dir, config, self)
    end

    desc "preview", "Start preview process"
    def preview
      project = Forge::Project.new('.', self)

      Forge::Guard.start
    end
  end
end