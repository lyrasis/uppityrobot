Feature: Monitors Delete
  Scenario: With an invalid argument
    When I run `uppityrobot m delete unknown 1`
    Then the JSON response at "error" should include "Field not recognized"

  Scenario: With a matching id
    When I run `uppityrobot m delete id 777749809`
    Then the JSON response at "stat" should be "ok"
    And  the JSON response at "monitor/id" should be 777749809

  Scenario: With a matching name
    When I run `uppityrobot m delete name Google`
    Then the JSON response at "stat" should be "ok"
    And  the JSON response at "monitor/id" should be 777749809

  Scenario: Without a matching id
    When I run `uppityrobot m delete name 123456789`
    Then the JSON response at "stat" should be "fail"
    And  the JSON response at "error" should include "Unique record lookup failed"


  Scenario: Without a matching name
    When I run `uppityrobot m delete name LYRASIS`
    Then the JSON response at "stat" should be "fail"
    And  the JSON response at "error" should include "Unique record lookup failed"
