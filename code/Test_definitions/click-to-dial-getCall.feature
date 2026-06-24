Feature: CAMARA Click to Dial API, v0.2.0-rc.1 - Operation getCall
    # Input to be provided by the implementation to the tester
    #
    # Implementation indications:
    # * apiRoot: API root of the server URL
    #
    # References to OAS spec schemas refer to schemas specified in click-to-dial.yaml

  Background: Common getCall setup
    Given an environment at "apiRoot"
    And the resource "/click-to-dial/v0.2rc1/calls/{callId}"
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

  @getcall_failure_malformed_callid
  Scenario: Fail to get call details due to malformed callId path parameter
    Given the request path parameter "callId" is set to a value that does not comply with the CallId schema
    When the request "getCall" is sent
    Then the response status code is 400
    And the response header "Content-Type" is "application/json"
    And the response body complies with the OAS schema at "/components/schemas/ErrorInfo"
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"

  @getcall_failure_authentication
  Scenario: Fail to get call details due to invalid or missing token
    Given an invalid or missing authentication token for the service
    And the request path parameter "callId" is set to a valid call identifier
    When the request "getCall" is sent
    Then the response status code is 401
    And the response header "Content-Type" is "application/json"
    And the response body complies with the OAS schema at "/components/schemas/ErrorInfo"
    And the response property "$.status" is 401
    And the response property "$.code" is "UNAUTHENTICATED"

  @getcall_failure_authorization
  Scenario: Fail to get call details due to insufficient permission
    Given a valid authentication token with insufficient permissions
    And the request path parameter "callId" is set to a valid call identifier
    When the request "getCall" is sent
    Then the response status code is 403
    And the response header "Content-Type" is "application/json"
    And the response body complies with the OAS schema at "/components/schemas/ErrorInfo"
    And the response property "$.status" is 403
    And the response property "$.code" is "PERMISSION_DENIED"

  @getcall_failure_unknown_callid
  Scenario: Fail to get call details due to well-formed but unknown callId
    Given the request path parameter "callId" is set to a well-formed callId that does not exist in the system
    When the request "getCall" is sent
    Then the response status code is 404
    And the response header "Content-Type" is "application/json"
    And the response body complies with the OAS schema at "/components/schemas/ErrorInfo"
    And the response property "$.status" is 404
    And the response property "$.code" is "NOT_FOUND"
