Feature: Main Menu
  In order to have a basic navigation on the page
  As a visitor
  I want to have direct access to certain features

  Scenario: Login button
    Given I am not logged in
    And I am on the home page
    When I follow "Login"
    Then I should be on the login page

  Scenario: User menu
    Given a user "Robert"
    And I am logged in as "Robert"
    When I go the home page
    Then I should not see "Login"
    But I should see "Robert"
    When I follow "Robert"
    Then I should be on the account page
