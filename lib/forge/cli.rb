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
    method_option :wp_dir, :type => :string, :desc => "Existing WordPress installation directory"
    method_option :interactive, :type => :boolean, :desc => "Use interactive configuration setup", :aliases => "-i"
    def create(dir)
      prompts = {
        :name       => "What is the name of this theme?",
        :uri        => "What is the website for this theme?",
        :author     => "Who is the author of this theme?",
        :author_uri => "What is the author's website?"
      }

      theme = {}

      prompts.each do |k,v|
        theme[k] = options[k]
        theme[k] = ask(v) if options[:interactive]
      end

      theme[:name] = dir if (theme[:name].nil? || theme[:name].empty?)

      project = Forge::Project.create(dir, theme, self)

      path = options[:wp_dir] || ask("Please enter the path to your wordpress install.").chomp

      unless path.empty?
        begin
          project.link(path)
        rescue LinkSourceNotFound
          say "Sorry, we couldn't find a wordpress installation at #{path}\n"
          exit 1
        end
      else
        say "No wordpress install specified\n"
      end
      say "You can link to additional wordpress installs using the 'forge link' command\n"
    end

    desc "link WORDPRESS_DIR", "symlink this theme to the specified wordpress install"
    def link(wordpress_dir)
      project = Forge::Project.new('.', self)

      begin
        project.link(wordpress_dir)
      rescue LinkSourceNotFound
        say "Sorry, we couldn't find a wordpress installation at #{wordpress_dir}"
        exit 1
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