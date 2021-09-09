Feature: Monitors Exec
  Scenario: With an invalid argument
    When I run `uppityrobot m exec nonsense aspace`
    Then the JSON response at "error" should include "Task not recognized"

  Scenario: With a pause request for "My Web Page"
    When I run `uppityrobot m exec pause "My Web Page"`
    Then the JSON response at "total" should be 1
    And  the JSON response at "monitors/0/monitor/id" should be 777712827

  Scenario: With a start request for "My Web Page"
    When I run `uppityrobot m exec start "My Web Page"`
    Then the JSON response at "total" should be 1
    And  the JSON response at "monitors/0/monitor/id" should be 777712827
