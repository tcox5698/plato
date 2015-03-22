@javascript
Feature: Ideas page

  Scenario: Anonymous user does not see Ideas page
    When I am not logged in
    And I visit the Ideas page
    Then I see the login page
    And I see a login link
    And I see the 'Please login' error message

  Scenario: User sees only their own ideas
    Given the following users
      | email           | password   |
      | bob@smith.com   | Password1! |
      | nancy@jones.com | Password2! |
    And the following ideas
      | user_email      | idea_name         |
      | bob@smith.com   | bob's idea   |
      | nancy@jones.com | nancys idea |
    When I log in as 'bob@smith.com' with password 'Password1!'
    And I visit the Ideas page
    Then I see only the following ideas
      | idea_name       |
      | bob's idea |

