Feature: CAMARA Click to Dial API, v0.1.0-alpha.2 - Operation terminateCall
    # Input to be provided by the implementation to the tester
    #
    # Implementation indications:
    # * apiRoot: API root of the server URL
    #
    # References to OAS spec schemas refer to schemas specified in click-to-dial.yaml

  Background: Common terminateCall setup
    Given an environment at "apiRoot"       |
    And the header "Content-Type" is set to "application/json"
    And the header "Authorization" is set to a valid access token
        # Path parameters not explicitly overwritten in the Scenarios can take any values compliant with the schema

    # Success scenarios
  @terminatecall_success
  Scenario: Terminate call successfully
    Given a valid call identifier obtained from a previous createCall response
    And the request path parameter "callId" is set to that identifier
    When the request "terminateCall" is sent
    Then the response status code is 204

  @terminatecall_failure_missing_callid
  Scenario: Fail to terminate call due to missing callId path parameter
    When the request "terminateCall" is sent
    Then the response status code is 400
    And the response header "Content-Type" is "application/json"
    And the response body complies with the OAS schema at "/components/schemas/ErrorInfo"

  @terminatecall_failure_authentication
  Scenario: Fail to terminate call due to authentication failure
    Given an invalid or missing authentication token for the service
    And the request path parameter "callId" is set to a valid call identifier
    When the request "terminateCall" is sent
    Then the response status code is 401
    And the response header "Content-Type" is "application/json"
    And the response body complies with the OAS schema at "/components/schemas/ErrorInfo"

  @terminatecall_failure_invalid_callidentifier
  Scenario: Fail to terminate call due to invalid call identifier
    Given an invalid call identifier
    And the request path parameter "callId" is set to that identifier
    When the request "terminateCall" is sent
    Then the response status code is 404
    And the response header "Content-Type" is "application/json"
    And the response body complies with the OAS schema at "/components/schemas/ErrorInfo"

  @terminatecall_failure_conflict
  Scenario: Fail to terminate call due to conflicting state
    Given a call identifier for a call that cannot be terminated (already ended or conflicting state)
    And the request path parameter "callId" is set to that identifier
    When the request "terminateCall" is sent
    Then the response status code is 409
    And the response header "Content-Type" is "application/json"
    And the response body complies with the OAS schema at "/components/schemas/ErrorInfo"
