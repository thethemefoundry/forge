require 'thor'
require 'yaml'
require 'guard/forge/assets'
require 'guard/forge/config'
require 'guard/forge/templates'

module Forge
  class CLI < Thor
    include Thor::Actions

    def self.source_root
      File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'templates'))
    end

    desc "init DIRECTORY", "Initializes a Forge project"
    method_options :prompt => :boolean
    def init(dir)
      config = {
        :name => dir
      }

      if options.prompt?
        config = {
          :name       => ask("What is the name of this theme?"),
          :uri        => ask("What is the website for the theme?"),
          :author     => ask("What is the author's name?"),
          :author_url => ask("What is the author's url?")
        }
      end

      project = Forge::Project.create(dir, config, self)
    end

    desc "link WORDPRESS_DIR", "symlink this theme to the specified wordpress install"
    def link(wordpress_dir)
      project = Forge::Project.new('.', self)

      wordpress_dir = File.expand_path(wordpress_dir)
      target = File.join(project.root, '.forge')
      source = File.join(wordpress_dir, 'wp-content', 'themes', project.name)

      link_file target, source
    end

    desc "watch", "Start watch process"
    def watch
      project = Forge::Project.new('.', self)

      Forge::Guard.start(project, self)
    end

    desc "package", "Compile and zip your project"
    def package
      project = Forge::Project.new('.', self)

      builder = Builder.new(project)
      builder.build
      builder.zip
    end
  end
end