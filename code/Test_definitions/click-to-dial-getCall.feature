Feature: CAMARA Click to Dial API, vwip - Operation getCall
    # Input to be provided by the implementation to the tester
    #
    # Implementation indications:
    # * apiRoot: API root of the server URL
    #
    # References to OAS spec schemas refer to schemas specified in click-to-dial.yaml

  Background: Common getCall setup
    Given an environment at "apiRoot"
    And the resource "/click-to-dial/vwip/calls/{callId}"
    And the header "Content-Type" is set to "application/json"
    And the header "Authorization" is set to a valid access token
    And the header "x-correlator" is set to a valid UUID
    And the header "x-correlator" complies with the schema at "#/components/schemas/XCorrelator"
    # Path parameters not explicitly overwritten in the Scenarios can take any values compliant with the schema

    # Success scenarios
  @getcall_success
  Scenario: Get call details successfully
    Given a valid call identifier obtained from a previous createCall response
    And the request path parameter "callId" is set to that identifier
    When the request "getCall" is sent
    Then the response status code is 200
    And the response header "Content-Type" is "application/json"
    And the response header "x-correlator" has the same value as the request header "x-correlator"
    And the response body complies with the OAS schema at "/components/schemas/Call"

  @getcall_failure_invalid_request
  Scenario: Fail to get call details due to invalid request
    Given an invalid request with missing or malformed path parameter
    When the request "getCall" is sent
    Then the response status code is 400
    And the response header "Content-Type" is "application/json"
    And the response body complies with the OAS schema at "/components/schemas/ErrorInfo"

  @getcall_failure_authentication
  Scenario: Fail to get call details due to authentication failure
    Given an invalid or missing authentication token for the service
    And the request path parameter "callId" is set to a valid call identifier
    When the request "getCall" is sent
    Then the response status code is 401
    And the response header "Content-Type" is "application/json"
    And the response body complies with the OAS schema at "/components/schemas/ErrorInfo"

  @getcall_failure_authorization
  Scenario: Fail to get call details due to authorization failure
    Given a valid authentication token with insufficient permissions
    And the request path parameter "callId" is set to a valid call identifier
    When the request "getCall" is sent
    Then the response status code is 403
    And the response header "Content-Type" is "application/json"
    And the response body complies with the OAS schema at "/components/schemas/ErrorInfo"

  @getcall_failure_invalid_callidentifier
  Scenario: Fail to get call details due to unknown call identifier
    Given an invalid call identifier
    And the request path parameter "callId" is set to that identifier
    When the request "getCall" is sent
    Then the response status code is 404
    And the response header "Content-Type" is "application/json"
    And the response body complies with the OAS schema at "/components/schemas/ErrorInfo"
