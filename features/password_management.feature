Feature: Password management
  In order to manage my password
  As a registered user
  I want to have my password updated in the system

  Scenario: forgot password page
    Given I am not logged in
    And I am on the login page
    When I follow "Forgot your password?"
    Then I should be on the forgot password page

  Scenario: request password reset
    Given I am not logged in
    And a user "Robert"
    And user "Robert" has e-mail set to "test@example.com"
    And I am on the forgot password page
    When I fill in "Email" with "test@example.com"
    And I click "Send me reset password instruction"
    Then an e-mail with password reset request link should be sent to "test@example.com"
    And I should be on the login page

