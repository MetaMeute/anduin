Feature: user creation
  In order to be a part of anduin
  As a visitor
  I want to create an account

  Scenario: click the sign up link
    Given I am not logged in
    And I am on the login page
    When I follow "Sign up"
    Then I should be on the sign up page

  Scenario: provide empty password
    Given I am on the sign up page
    When I fill in "Nick" with "Robert"
    And I click "Sign up"
    Then I should be on the sign up page
    And I should see "Password can’t be blank"

  Scenario: passwords don’t match
    Given I am on the sign up page
    When I fill in "Nick" with "Robert"
    And I fill in "Password" with "secret!"
    And I fill in "Password confirmation" with "another secret!"
    And I click "Sign up"
    Then I should be on the sign up page
    And I should see "Passwords do not match"

  Scenario: duplicate account
    Given I am on the sign up page
    And there is no user named "Robert"
    When I fill in "Nick" with "Robert"
    And I fill in "Password" with "secret!"
    And I fill in "Password confirmation" with "secret!"
    And I click "Sign up"
    Then I should be on the sign in page
    When I follow "Sign up"
    And I fill in "Nick" with "Robert"
    And I fill in "Password" with "secret!"
    And I fill in "Password confirmation" with "secret!"
    And I click "Sign up"
    Then I should be on the sign up page
    And I should see "Entry Already Exists"
    Given there is no user named "Robert"

  Scenario: sign up successful
    Given I am on the sign up page
    And there is no user named "Robert"
    When I fill in "Nick" with "Robert"
    And I fill in "Password" with "secret!"
    And I fill in "Password confirmation" with "secret!"
    And I click "Sign up"
    Then I should be on the sign in page
    And I should see "User created, now please sign in."
    Given there is no user named "Robert"

