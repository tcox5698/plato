Feature: Landing page

  Scenario: Anonymous user sees landing page
    When I am not logged in
    And I visit the Home page
    Then I see the landing page
    And I see a login link
    And I see no error messages
