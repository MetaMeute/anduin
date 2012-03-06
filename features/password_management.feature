Feature: Password management
  In order to manage my password
  As a registered user
  I want to have my password updated in the system

  Scenario: forgot password page
    Given I am not logged in
    And I am on the login page
    When I follow "Forgot Password"
    Then I should be on the forgot password page

  Scenario: request password reset
    Given I am not logged in
    And I am on the forgot password page
    When I fill in "E-Mail" with "test@example.com"
    And I click "Request Password Reset"
    Then an e-mail with password reset request link should be sent
    And I should be on the login page

