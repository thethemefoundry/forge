Feature: Initialize a new Forge project

  Scenario: Creating a brand new project with all arguments
    When I successfully run `forge create foo --name=foo_theme --uri=http://www.footheme.com --author="Foo Man" --author_uri=http://www.fooman.com`
    Then the following directories should exist:
      | foo/assets/javascripts        |
      | foo/assets/stylesheets        |
      | foo/assets/images             |
      | foo/templates/core            |
      | foo/templates/custom/partials |
    And the following files should exist:
      | foo/config.yml                        |
      | foo/assets/stylesheets/style.css.scss |
    And the file "foo/config.yml" should contain:
      | name: foo_theme                   |
      | uri: http://www.footheme.com      |
      | author: Foo Man                   |
      | author_uri: http://www.fooman.com |

  Scenario: Creating a new project without any arguments
    When I run `forge create foo` interactively
    And I type "foo_theme"
    And I type "http://www.footheme.com"
    And I type "Foo Man"
    And I type "http://www.fooman.com"
    Then the following directories should exist:
      | foo/assets/javascripts        |
      | foo/assets/stylesheets        |
      | foo/assets/images             |
      | foo/templates/core            |
      | foo/templates/custom/partials |
    And the following files should exist:
      | foo/config.yml                        |
      | foo/assets/stylesheets/style.css.scss |
    And the file "foo/config.yml" should contain:
      | name: foo_theme                   |
      | uri: http://www.footheme.com      |
      | author: Foo Man                   |
      | author_uri: http://www.fooman.com |