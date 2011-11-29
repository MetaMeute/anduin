Feature: Recent changes
  In order be informed about what recently happened
  As a wiki user
  I want to have access to recent activities in the wiki

  @wip
  Scenario: show the global history
    Given I am on the wiki front page
    When I follow "Recent Changes"
    Then I should see "Recent Changes"

  Scenario: show the history of a page
    Given I am on the wiki front page
    When I follow "History"
    Then I should see a list with changes

