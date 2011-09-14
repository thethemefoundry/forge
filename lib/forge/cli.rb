require 'thor'
require 'yaml'
require 'guard/forge/assets'
require 'guard/forge/config'
require 'guard/forge/templates'

module Forge
  class CLI < Thor
    include Thor::Actions

    def self.source_root
      File.expand_path(File.join(File.dirname(__FILE__), '..', '..', 'layouts'))
    end

    desc "init DIRECTORY", "Initializes a Forge project"
    method_option :name, :type => :string, :desc => "The theme name"
    method_option :uri,  :type => :string, :desc => "The theme's uri"
    method_option :author, :type => :string, :desc => "The author of the theme"
    method_option :author_url, :type => :string, :desc => "The author's url"
    def init(dir)
      config = Forge::Config.read

      prompts = {
        :name       => "What is the name of this theme?",
        :uri        => "What is the website for this theme?",
        :author     => "Who is the author of this theme?",
        :author_url => "What is the author's website?"
      }

      theme = {}

      prompts.each do |k,v|
        # Check if this option was passed as a switch, or put in the user config
        # before prompting the user
        theme[k] = options[k] || config[:theme][k] || ask(v)
      end

      project = Forge::Project.create(dir, theme, self)
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