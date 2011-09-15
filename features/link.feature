Feature: Symbolic link creation via the link command

  Scenario: Linking a project to a WordPress install
    Given a WordPress installation exists at "wordpress"
    And I am in a forge project named "awesome_theme"
    When I successfully run `forge link ../wordpress`
    Then a directory named "../wordpress/wp-content/themes/awesome_theme" should exist

  Scenario: Linking a project to a bogus directory
    Given I am in a forge project named "awesome_theme"
    When I run `forge link ../wordpress`
    Then the exit status should be 1
    And the output should contain "Sorry, we couldn't find a wordpress installation"
    And a directory named "../wordpress/wp-content/themes/awesome_theme" should not exist