@javascript
Feature: New user registration

  Scenario: When a user registers without OAuth they land on the login page.
    When I visit the Home page
    And I register user 'register@me.com' with password 'Password7!'
    Then I see the Login page
    When I log in as 'register@me.com' with password 'Password7!'
    Then I see the landing page
    And I see the 'Logout' link