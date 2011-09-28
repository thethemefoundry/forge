require 'thor'
require 'yaml'
require 'guard/forge/assets'
require 'guard/forge/config'
require 'guard/forge/templates'
require 'guard/forge/functions'

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

      # Empty the build directory before starting up to clean out old files
      FileUtils.rm_rf project.build_path
      FileUtils.mkdir_p project.build_path

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
      rescue Errno::EEXIST
        say_status :error, "The path #{path} already exsts", :red
        exit 2
      end
    end
  end
end
