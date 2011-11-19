## Forge is a toolkit for bootstrapping and developing WordPress themes.

[Forge website](http://forge.thethemefoundry.com/)

[User's manual](http://forge.thethemefoundry.com/manual)

-----

Current Version: **0.2.0**

Install Forge (requires [Ruby](http://www.ruby-lang.org/) and [RubyGems](http://rubygems.org/)):

    $ gem install forge

Create your new theme project:

    $ forge create your_theme

Change to your new project directory:

    $ cd your_theme

Link to your WordPress theme folder:

    $ forge link /path/to/wordpress/wp-content/themes/your_theme

Watch for changes and start developing!

    $ forge watch

Press Ctrl + C to exit watch mode

Build your theme into the build_here directory:

    $ forge build build_here

Package your theme as your_theme.zip:

    $ forge package your_theme

Get a little help with the Forge commands:

    $ forge help

See the [user's manual](http://forge.thethemefoundry.com/manual) for more information.