Feature: Change shell for a user

  In order to let everybody decide about their own shell
  as a user with a posix account
  I want be able to change my shell.

  Scenario: show default shell
    Given a user "Robert"
    And I am logged in as "Robert"
    When I visit my account settings page
    Then I should see "Login shell"
    And I should see "/bin/bash"
  
