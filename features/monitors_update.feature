Feature: Monitors Update
  Scenario: With an invalid format
    When I run `uppityrobot m update xml test.xml`
    Then the JSON response at "error" should include "Format not recognized"

  Scenario: With invalid CSV
    Given a file named "test.csv" with:
      """
      c,s,v,1
      one,two",three,four
      """
    When I run `uppityrobot m update csv test.csv`
    Then the JSON response at "error" should include "Invalid input"

  Scenario: With an invalid JSON file
    Given a file named "test.json" with:
      """
      [{abc: 123}]
      """
    When I run `uppityrobot m update json test.json`
    Then the JSON response at "error" should include "Invalid input"

  Scenario: With an invalid JSON string
    When I run `uppityrobot m update json '[{abc: 123}]'`
    Then the JSON response at "error" should include "Invalid input"

  Scenario: With invalid data
    When I run `uppityrobot m update json '{"abc": 123}'`
    Then the JSON response at "error" should include "Data must be an array"

  Scenario: With valid CSV data
    Given a file named "test.csv" with:
      """
      id,status
      777712827,1
      777712827,1
      """
    When I run `uppityrobot m update csv test.csv`
    Then the JSON response at "stat" should be "ok"
    And  the JSON response at "total" should be 2
    And  the JSON response at "updated" should be 2

  Scenario: With valid JSON data
    Given a file named "test.json" with:
      """
      [
        {"id": 777712827, "status": 1},
        {"id": 777712827, "status": 1}
      ]
      """
    When I run `uppityrobot m update json test.json`
    Then the JSON response at "stat" should be "ok"
    And  the JSON response at "total" should be 2
    And  the JSON response at "updated" should be 2
