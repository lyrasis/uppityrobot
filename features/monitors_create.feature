Feature: Monitors Create
  Scenario: Without all required arguments
    When I run `uppityrobot m create google www.google.com`
    Then the output should contain "NAME URL CONTACTS"

  Scenario: With an invalid URI
    When I run `uppityrobot m create google www.google.com 1`
    Then the JSON response at "error" should include "URL must be HTTP/S"

  Scenario: With all required arguments
    When I run `uppityrobot m create google https://www.google.com 1`
    Then the JSON response at "stat" should be "ok"
    And  the JSON response at "monitor/status" should be 1
