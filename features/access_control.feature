Feature: Access control

Scenario Outline: Access granted for admin
  Given I am logged in as an admin
  And an event "My event"
  
  When I go to <page>
  
  Then I should not get an 403 status code
  And I should not be redirected
  
  Examples:
    | page                              |
    | the homepage                      |
    | the events page                   |
    | the event page for "My event"    |
    | the new reply page for "My event" |
    | the economy page for "My event"   |

Scenario Outline: Access denied for not logged in
  Given an event "My event"
  
  When I go to <page>
  
  Then I should see "Du har inte rätt att se denna sida"
  And I should not be on the login page
  
  Examples:
    | page                              |
    | the events page                   |

Scenario Outline: Access denied with redirect to event login for not logged in
  Given an event "My event"
  
  When I go to <page>
  
  Then I should be on the event login page for "My event"
  
  Examples:
    | page                            |
    | the event page for "My event"   |
    | the economy page for "My event" |
    
Scenario Outline: Access granted for not logged in
  Given an event "My event"
  When I go to <page>
  
  Then I should not get an 403 status code
  And I should not be on the login page
  And I should not be on the event login page for "My event"

  Examples: 
    |page|
    | the homepage|
    | the new event page                |
    | the new reply page for "My event"|