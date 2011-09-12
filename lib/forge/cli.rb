require 'thor'
require 'yaml'

module Forge
  class CLI < Thor
    include Thor::Actions
    attr_reader :name, :uri, :author, :author_uri, :description, :version_number, :license_name, :license_uri, :tags

    def self.source_root
      File.join(File.dirname(__FILE__), 'templates')
    end

    desc "init NAME", "Initializes a Forge project"
    def init(name)
      @name = ask "What is the name of the theme?"
      @uri = ask "What is the website for the theme?"
      @author = ask "What is the author's name?"
      @author_uri = ask "What is the author's website?"

      empty_directory name

      empty_directory File.join(name, "assets", "images")
      empty_directory File.join(name, "assets", "javascripts")
      empty_directory File.join(name, "assets", "stylesheets")

      empty_directory File.join(name, "templates", "core")
      empty_directory File.join(name, "templates", "custom", "pages")
      empty_directory File.join(name, "templates", "custom", "partials")

      empty_directory File.join(name, "functions")

      template File.join("config", "config.yml.erb"), File.join(name, "config.yml")

      template File.join("stylesheets", "style.css.erb"), File.join(name, "assets", "stylesheets", "style.css")
    end

    desc "preview", "Start preview process"
    def preview
      unless File.exists?('config.yml')
        puts "No configuration file found - are you sure you're in a Forge project directory?"
        exit
      end

      Forge.config = YAML.load(File.open('config.yml'))

      guardfile_contents = %Q{
        guard 'forge' do
          watch(%r{.*})
        end
      }

      Guard.start({ :guardfile_contents => guardfile_contents })
    end
  end
end