Feature: file upload in wiki
  In order to create file references on a wiki-page
  As a wiki editor
  I want to upload files

  Background:
    Given I am logged in as "Robert"
    And a catalog named "Wiki Files"

  Scenario: visit the upload page
    Given I am on the wiki front page
    When I follow "Upload File"
    Then I should see a form with fields:
      | Field Name  |
      | Name        |
      | Catalog     |
      | File        |

  @wip
  Scenario: upload a file
    Given I am on the wiki front page
    When I follow "Upload File"
    And I fill in "meutelogo" into "Name"
    And I select "Wiki Files" from "Catalog"
    And I upload the testfile "meutelogo_black.png"
    And I submit the form
    Then the file "meutelogo.png" is part of the wiki

