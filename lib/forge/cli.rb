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

    desc "create DIRECTORY", "Creates a Forge project"
    method_option :name, :type => :string, :desc => "The theme name"
    method_option :uri,  :type => :string, :desc => "The theme's uri"
    method_option :author, :type => :string, :desc => "The author of the theme"
    method_option :author_uri, :type => :string, :desc => "The author's uri"
    def create(dir)
      prompts = {
        :name       => "What is the name of this theme?",
        :uri        => "What is the website for this theme?",
        :author     => "Who is the author of this theme?",
        :author_uri => "What is the author's website?"
      }

      theme = {}

      prompts.each do |k,v|
        theme[k] = options[k] || ask(v)
      end

      project = Forge::Project.create(dir, theme, self)

      if path = ask("Please enter the path to your wordpress install.")
        say "Linking to #{path}"

        begin
          project.link(path)
        rescue LinkSourceNotFound
          say "Sorry, we couldn't find a wordpress installation at #{path}"
        end
      else
        say "No wordpress install specified"
      end
      say "You can link to additional wordpress installs using the 'forge link' command"
    end

    desc "link WORDPRESS_DIR", "symlink this theme to the specified wordpress install"
    def link(wordpress_dir)
      project = Forge::Project.new('.', self)

      begin
        project.link(wordpress_dir)
      rescue LinkSourceNotFound
        say "Sorry, we couldn't find a wordpress installation at #{wordpress_dir}"
      end
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