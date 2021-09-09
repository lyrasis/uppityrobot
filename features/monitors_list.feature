Feature: Monitors List
  Scenario: with no options returns all monitors
    When I run `uppityrobot monitors list`
    Then the JSON response at "monitors" should have 2 entries
    And  the JSON response at "monitors/0/friendly_name" should be "Google"
    And  the JSON response at "monitors/1/friendly_name" should be "My Web Page"

  Scenario: with the search "Google" returns only "Google"
    When I run `uppityrobot monitors list --search Google`
    Then the JSON response at "monitors" should have 1 entry
    And  the JSON response at "monitors/0/friendly_name" should be "Google"
    And  the output should not contain 'My Web Page'

  Scenario: with the filter "My Web Page" returns only "My Web Page"
    When I run `uppityrobot monitors list --filter '{"friendly_name": "My Web Page"}'`
    Then the JSON response at "monitors" should have 1 entry
    And  the JSON response at "monitors/0/friendly_name" should be "My Web Page"
    And  the output should not contain 'Google'

  Scenario: with the filter "status 1" returns only "Google"
    When I run `uppityrobot monitors list --filter '{"status": 1}'`
    Then the JSON response at "monitors" should have 1 entry
    And  the JSON response at "monitors/0/friendly_name" should be "Google"
    And  the output should not contain 'My Web Page'

  Scenario: save output to csv
    When I run `uppityrobot monitors list --csv test.csv`
    Then the file "test.csv" should exist
    And  the file "test.csv" should contain "Google"
