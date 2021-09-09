Feature: Monitors List
  Scenario: with no options returns all monitors
    When I run `uppityrobot monitors list`
    Then the output should contain 'Google'
    And the output should contain 'My Web Page'

  Scenario: with the search "Google" returns only "Google"
    When I run `uppityrobot monitors list --search Google`
    Then the output should contain 'Google'
    And the output should not contain 'My Web Page'

  Scenario: with the filter "Google" returns only "Google"
    When I run `uppityrobot monitors list --filter '{"friendly_name": "Google"}'`
    Then the output should contain 'Google'
    And the output should not contain 'My Web Page'

  Scenario: with the filter "status 1" returns only "Google"
    When I run `uppityrobot monitors list --filter '{"status": 1}'`
    Then the output should contain 'Google'
    And the output should not contain 'My Web Page'
