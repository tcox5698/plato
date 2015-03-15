Feature: Ideas page

  @javascript
  Scenario: Anonymous user does not see Ideas page
    When I am not logged in
    And I navigate to ideas page
    Then I see the login page
    And I see a login link
    And I see the 'Please login' error message.
