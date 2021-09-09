Feature: Exec
  Scenario: With an invalid task
    When I run `uppityrobot exec getRabbits`
    Then the JSON response at "error" should include "Task not recognized"

  Scenario: With a getMonitors request
    When I run `uppityrobot exec getMonitors`
    Then the JSON response at "monitors" should have 2 entries
    And  the JSON response at "monitors/0/friendly_name" should be "Google"
    And  the JSON response at "monitors/1/friendly_name" should be "My Web Page"

  Scenario: with the search "Google" returns only "Google"
    When I run `uppityrobot exec getMonitors --params '{"search": "Google"}'`
    Then the JSON response at "monitors" should have 1 entry
    And  the JSON response at "monitors/0/friendly_name" should be "Google"
    And  the output should not contain 'My Web Page'
