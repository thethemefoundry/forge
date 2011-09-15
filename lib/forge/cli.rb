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

      path = ask("Please enter the path to your wordpress install.").chomp

      unless path.empty?
        do_link(path)
      else
        say "No wordpress install specified\n"
      end

      say "You can link to additional wordpress installs using the 'forge link' command\n"
    end

    desc "link PATH", "symlink the compiled version of theme to the specified path"
    long_desc "This command will symlink the compiled version of the theme to the specified path.\n\n"+
      "To compile the theme use the `forge watch` command"
    def link(path)
      project = Forge::Project.new('.', self)

      do_link(project, path)
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

    protected
    def do_link(project, path)
      begin
        project.link(path)
      rescue LinkSourceDirNotFound
        say_status :error, "The path #{File.dirname(path)} does not exist", :red
        exit 2
      end
    end
  end
end