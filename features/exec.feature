Feature: Exec
  Scenario: With an invalid task
    When I run `uppityrobot exec getRabbits`
    Then the JSON response at "error" should include "Task not recognized"

  Scenario: With a getAlertContacts request
    When I run `uppityrobot exec getAlertContacts`
    Then the JSON response at "alert_contacts" should have 2 entries
    And  the JSON response at "alert_contacts/0/friendly_name" should be "John Doe"
    And  the JSON response at "alert_contacts/1/friendly_name" should be "My Twitter"

  Scenario: With a getMonitors request
    When I run `uppityrobot exec getMonitors`
    Then the JSON response at "monitors" should have 2 entries
    And  the JSON response at "monitors/0/friendly_name" should be "Google"
    And  the JSON response at "monitors/1/friendly_name" should be "My Web Page"

  Scenario: with a getMonitors request search for "Google" returns only "Google"
    When I run `uppityrobot exec getMonitors --params '{"search": "Google"}'`
    Then the JSON response at "monitors" should have 1 entry
    And  the JSON response at "monitors/0/friendly_name" should be "Google"
    And  the output should not contain 'My Web Page'
