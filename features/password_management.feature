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

  Scenario: reset password
    Given I request a password reset
    When I click the reset link in the email
    And I fill in "New password" with "secure"
    And I fill in "Confirm new password" with "secure"
    And I click "Change my password"
    Then I should be logged in

  Scenario: set e-mail address
    Given a user "Robert"
    And I am logged in as "Robert"
    When I follow "Robert"
    And I fill in "Email" with "test@example.com"
    And I click "Update User"
    Then I should see "Account updated"

  Scenario: change password successfully
    Given a user "Robert"
    And I am logged in as "Robert"
    When I follow "Robert"
    And I fill in "New password" with "secure"
    And I fill in "Confirm new password" with "secure"
    And I click "Update User"
    Then I should see "Account updated"
    And my password should be "secure"
