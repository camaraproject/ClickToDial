Feature: CAMARA Click to Dial API, v0.1.0-alpha.1 - Operation clickToDialRelease
    # Input to be provided by the implementation to the tester
    #
    # Implementation indications:
    # * apiRoot: API root of the server URL
    #
    # References to OAS spec schemas refer to schemas specified in click-to-dial.yaml, version 0.1.0-alpha.1

  Background: Common ClickToDialRelease setup
    Given an environment at "apiRoot"       |
    And the header "Content-Type" is set to "application/json"
    And the header "Authorization" is set to a valid access token
        # Properties not explicitly overwitten in the Scenarios can take any values compliant with the schema
    And the request body is set by default to a request body compliant with the schema at "/components/schemas/ClickToDialReleaseRequest"

    # Success scenarios
  @clicktodialrelease_success
  Scenario: Common validations for ClickToDialRelease success scenario
    Given a valid call identifier obtained from a previous ClickToDialBegin response
    And the request property "$.operation" is set to a valid operation, for example "EndCall"
    When the request "ClickToDialRelease" is sent
    Then the response status code is 200

  @clicktodialrelease_failure_missing_operation
  Scenario: Fail to release call due to missing operation field in ClickToDialRelease request
    Given a valid call identifier obtained from a previous ClickToDialBegin response
    # The request is missing the "operation" property
    When the request "ClickToDialRelease" is sent
    Then the response status code is 400
    And the response header "Content-Type" is "application/json"
    And the response body complies with the OAS schema at "/components/schemas/ErrorInfo"
    And the response property "$.code" is "1001003"
    And the response property "$.description" is "Operation Error"

  @clicktodialrelease_failure_authentication
  Scenario: Fail to release call due to authentication failure in ClickToDialRelease request
    Given an invalid or missing authentication token for the service
    And the request property "$.operation" is set to a valid operation, for example "EndCall"
    When the request "ClickToDialRelease" is sent
    Then the response status code is 400
    And the response header "Content-Type" is "application/json"
    And the response body complies with the OAS schema at "/components/schemas/ErrorInfo"
    And the response property "$.code" is "0001004"
    And the response property "$.description" is "Authentication Failure"

  @clicktodialrelease_failure_invalid_callidentifier
  Scenario: Fail to release call due to invalid call identifier in ClickToDialRelease request
    Given an invalid call identifier
    And the request property "$.operation" is set to a valid operation, for example "EndCall"
    When the request "ClickToDialRelease" is sent
    Then the response status code is 400
    And the response header "Content-Type" is "application/json"
    And the response body complies with the OAS schema at "/components/schemas/ErrorInfo"
    And the response property "$.code" is "1001002"
    And the response property "$.description" is "Call ID Error"

  @clicktodialrelease_failure_server_error
  Scenario: Fail to release call due to server error in ClickToDialRelease request
    Given a valid call identifier obtained from a previous ClickToDialBegin response
    And the request property "$.operation" is set to a valid operation, for example "EndCall"
    When the request "ClickToDialRelease" is sent
    Then the response status code is 500
    And the response header "Content-Type" is "application/json"
    And the response body complies with the OAS schema at "/components/schemas/ErrorInfo"
    And the response property "$.code" is "0000001"
    And the response property "$.description" is "Internal Service Error"