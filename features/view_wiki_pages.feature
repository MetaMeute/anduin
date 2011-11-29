Feature:
  In order to get informed about interesting things
  as a guest
  I want to browse the wiki pages.

  Scenario: Visit the front page
    Given I am on the wiki front page
    Then I should see the "Meutelogo" image
    And I should be on a wiki page named "FrontPage"
