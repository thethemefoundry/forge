Feature: Initialize a new Forge project

  Scenario: Creating a brand new project with all arguments
    Given a WordPress installation exists at "wordpress"
    When I successfully run `forge create foo --wp_dir=wordpress --name=foo_theme --uri=http://www.footheme.com --author="Foo Man" --author_uri=http://www.fooman.com`
    Then the forge skeleton should be created in directory "foo"
    And the file "foo/config.json" should contain:
      | "name": "foo_theme"                   |
      | "uri": "http://www.footheme.com"      |
      | "author": "Foo Man"                   |
      | "author_uri": "http://www.fooman.com" |

  Scenario: Creating a new project without any arguments
    Given a WordPress installation exists at "wordpress"
    When I run `forge create foo` interactively
    And I type "wordpress"
    Then the forge skeleton should be created in directory "foo"
    And the file "foo/config.json" should contain:
      | "name": "foo" |

  Scenario: Creating a new project with all prompts
    Given a WordPress installation exists at "wordpress"
    When I run `forge create foo -i` interactively
    And I type "foo_theme"
    And I type "http://www.footheme.com"
    And I type "Foo Man"
    And I type "http://www.fooman.com"
    And I type "wordpress"
    Then the forge skeleton should be created in directory "foo"
    And the file "foo/config.json" should contain:
      | "name": "foo_theme"                   |
      | "uri": "http://www.footheme.com"      |
      | "author": "Foo Man"                   |
      | "author_uri": "http://www.fooman.com" |