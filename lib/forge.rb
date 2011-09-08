require 'thor'

class Forge < Thor
  include Thor::Actions
  
  desc "init NAME", "Initializes a Forge project"
  def init(name)
    empty_directory name
    
    empty_directory File.join(name, "assets", "images")
    empty_directory File.join(name, "assets", "javascripts")
    empty_directory File.join(name, "assets", "stylesheets")
    
    empty_directory File.join(name, "templates", "core")
    empty_directory File.join(name, "templates", "custom", "pages")
    empty_directory File.join(name, "templates", "custom", "partials")
    
    empty_directory File.join(name, "functions")
  end
end