Feature: Exec
  Scenario: With an invalid task
    When I run `uppityrobot exec getRabbits`
    Then the output should contain 'Task not recognized'
