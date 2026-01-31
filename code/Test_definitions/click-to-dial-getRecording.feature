Feature: CAMARA Click to Dial API, v0.1.0-rc.1 - Operation getRecording
    # Input to be provided by the implementation to the tester
    #
    # Implementation indications:
    # * apiRoot: API root of the server URL
    #
    # References to OAS spec schemas refer to schemas specified in click-to-dial.yaml

  Background: Common getRecording setup
    Given an environment at "apiRoot"       |
    And the header "Content-Type" is set to "application/json"
    And the header "Authorization" is set to a valid access token
        # Path parameters not explicitly overwritten in the Scenarios can take any values compliant with the schema

    # Success scenarios
  @getrecording_success
  Scenario: Common validations for getRecording success scenario
    Given a valid call identifier obtained from a previous createCall response
    And the request path parameter "callId" is set to that identifier
    When the request "getRecording" is sent
    Then the response status code is 200
    And the response header "Content-Type" is "application/json"
    # The response has to comply with the OAS schema for RecordingResource
    And the response body complies with the OAS schema at "/components/schemas/RecordingResource"
    And the response property "$.callId" has the same value as the request path parameter "callId"
    And the response property "$.content" exists
    And the response property "$.contentType" is "audio/wav" or "audio/mp3" or "audio/mpeg" or "audio/ogg"
    And the response property "$.generatedAt" exists

  @getrecording_failure_missing_callid
  Scenario: Fail to download recording due to missing callId in getRecording request
    When the request "getRecording" is sent
    Then the response status code is 400
    And the response header "Content-Type" is "application/json"
    And the response body complies with the OAS schema at "/components/schemas/ErrorInfo"

  @getrecording_failure_authentication
  Scenario: Fail to download recording due to authentication failure in getRecording request
    Given an invalid or missing authentication token for the service
    And the request path parameter "callId" is set to a valid call identifier
    When the request "getRecording" is sent
    Then the response status code is 401
    And the response header "Content-Type" is "application/json"
    And the response body complies with the OAS schema at "/components/schemas/ErrorInfo"

  @getrecording_failure_invalid_callidentifier
  Scenario: Fail to download recording due to invalid call identifier in getRecording request
    Given an invalid call identifier
    And the request path parameter "callId" is set to that identifier
    When the request "getRecording" is sent
    Then the response status code is 404
    And the response header "Content-Type" is "application/json"
    And the response body complies with the OAS schema at "/components/schemas/ErrorInfo"

  @getrecording_failure_not_found
  Scenario: Fail to download recording because it is not available
    Given a call identifier with no available recording
    And the request path parameter "callId" is set to that identifier
    When the request "getRecording" is sent
    Then the response status code is 404
    And the response header "Content-Type" is "application/json"
    And the response body complies with the OAS schema at "/components/schemas/ErrorInfo"
