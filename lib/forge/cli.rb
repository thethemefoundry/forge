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
    method_option :struts, :type => :boolean, :desc => "Include Struts Options Framework"
    def create(dir)
      theme = {}
      theme[:name] = dir

      project = Forge::Project.create(dir, theme, self)
    end

    desc "link PATH", "symlink the compiled version of theme to the specified path"
    long_desc "This command will symlink the compiled version of the theme to the specified path.\n\n"+
      "To compile the theme use the `forge watch` command"
    def link(path)
      project = Forge::Project.new('.', self)

      FileUtils.mkdir_p project.build_path unless File.directory?(project.build_path)

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

    desc "build DIRECTORY", "Build your theme into specified directory"
    def build(dir='build')
      project = Forge::Project.new('.', self)

      builder = Builder.new(project)
      builder.build

      FileUtils.rm_rf Dir.glob(File.join(dir, '*'))
      directory(project.build_path, dir)
    end

    desc "package FILENAME", "Compile and zip your project to FILENAME.zip"
    def package(filename=nil)
      project = Forge::Project.new('.', self)

      builder = Builder.new(project)
      builder.build
      builder.zip(filename)
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
