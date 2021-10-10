## My Wordpress Project
##  Forge is a toolkit for bootstrapping and developing WordPress themes.

[Forge website](http://forge.thethemefoundry.com/)

[User's manual](http://forge.thethemefoundry.com/manual)

-----

Current Version: **0.5.0**

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

-----

**Note for upgrading existing projects to 0.5.0:**

As of version 0.5.0, Forge no longer generates the header of your **style.css** file based on the values in `config.rb`.

Instead, you need to write your own header and include it in **style.css.scss** yourself to generate a valid theme stylesheet.

If you have any questions on migrating, open a new issue and we'll help you sort it out!
