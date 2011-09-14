Feature: Initialize a new Forge project

  Scenario: Creating a brand new project
    When I successfully run `forge init foo --name=foo_theme --uri=http://www.footheme.com --author="Foo Man" --author_uri=http://www.author.com`
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
      | author_uri: http://www.author.com |

