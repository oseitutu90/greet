Feature: Greet Controller Integration Test

  Background:
    * url 'http://localhost:8080'

  Scenario: Verify greet endpoint returns expected response
    Given path '/greet'
    When method GET
    Then status 200
    And print 'Greeting: ' + response
    And match response contains 'Hello'

  Scenario: Verify health endpoint is working
    Given path '/actuator/health'
    When method GET
    Then status 200
    And print 'Health: ' + response
    And match response.status == 'UP'