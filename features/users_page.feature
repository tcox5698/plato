Feature: Users page

  Scenario: Anonymous user can not see users
    Given I am not logged in
    When I visit the Users page
    Then I see the Login page
    And I see the 'Please login' error message

  Scenario: Authenticated user can only see self
    Given the following users
      | email           | password   |
      | bob@smith.com   | Password1! |
      | nancy@jones.com | Password2! |
    When I log in as 'bob@smith.com' with password 'Password1!'
    And I visit the Users page
    Then I see only the following users listed
      | email         |
      | bob@smith.com |
