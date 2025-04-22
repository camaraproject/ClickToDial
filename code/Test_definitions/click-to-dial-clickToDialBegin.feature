Feature: Click to Dial Service API Validations
    # Input to be provided by the implementation to the tester
    #
    # Implementation indications:
    # * apiRoot: API root of the server URL
    #
    # References to OAS spec schemas refer to schemas specified in Click to Dial.yaml, version 0.1.0

  Background: Common ClickToDialBegin setup
    Given an environment at "apiRoot"       |
    And the header "Content-Type" is set to "application/json"
    And the header "Authorization" is set to a valid access token
        # Properties not explicitly overwitten in the Scenarios can take any values compliant with the schema
    And the request body is set by default to a request body compliant with the schema at "/components/schemas/ClickToDialBeginRequest"

    # Success scenarios

  @clicktodialbegin_success
  Scenario: Common validations for ClickToDialBegin success scenario
    # Valid testing device and default request body compliant with the schema
    Given a valid testing device supported by the service, identified by the token or provided in the request body
    And the request property "$.sponsor" is set to a valid sponsor number in E.164 fordmat
    And the request property "$.caller" is set to a valid caller number in E.164 format
    And the request property "$.callee" is set to a valid callee number in E.164 format
    When the request "ClickToDialBegin" is sent
    Then the response status code is 200
    And the response header "Content-Type" is "application/json"
    # The response has to comply with the OAS schema for ClickToDialBeginResponse
    And the response body complies with the OAS schema at "/components/schemas/ClickToDialBeginResponse"
    And the response property "$.code" is "0000000"
    And the response property "$.description" is "Success"
    And the response property "$.result.callidentifier" exists

  @clicktodialbegin_failure_missing_fields
  Scenario: Fail to initiate call due to missing required fields in ClickToDialBegin request
    Given a valid testing device supported by the service, identified by the token or provided in the request body
    # The request is missing the required "sponsor" property
    And the request property "$.caller" is set to a valid caller number in E.164 format
    And the request property "$.callee" is set to a valid callee number in E.164 format
    When the request "ClickToDialBegin" is sent
    Then the response status code is 400
    And the response header "Content-Type" is "application/json"
    And the response body complies with the OAS schema at "/components/schemas/ErrorInfo"
    And the response property "$.code" is "0000002"
    And the response property "$.description" is "Invalid Input Value"

  @clicktodialbegin_failure_authentication
  Scenario: Fail to initiate call due to authentication failure in ClickToDialBegin request
    Given an invalid or missing authentication token for the service
    And the request property "$.sponsor" is set to a valid sponsor number in E.164 format
    And the request property "$.caller" is set to a valid caller number in E.164 format
    And the request property "$.callee" is set to a valid callee number in E.164 format
    When the request "ClickToDialBegin" is sent
    Then the response status code is 400
    And the response header "Content-Type" is "application/json"
    And the response body complies with the OAS schema at "/components/schemas/ErrorInfo"
    And the response property "$.code" is "0001004"
    And the response property "$.description" is "Authentication Failure"

  @clicktodialbegin_failure_invalid_caller
  Scenario: Fail to initiate call due to invalid caller number in ClickToDialBegin request
    Given a valid testing device supported by the service, identified by the token or provided in the request body
    And the request property "$.sponsor" is set to a valid sponsor number in E.164 format
    And the request property "$.caller" is set to a invalid caller number in error format
    And the request property "$.callee" is set to a valid callee number in E.164 format
    When the request "ClickToDialBegin" is sent
    Then the response status code is 400
    And the response header "Content-Type" is "application/json"
    And the response body complies with the OAS schema at "/components/schemas/ErrorInfo"
    And the response property "$.code" is "1001001"
    And the response property "$.description" is "Number Format Error"

  @clicktodialbegin_failure_server_error
  Scenario: Fail to initiate call due to server error in ClickToDialBegin request
    Given a valid testing device supported by the service, identified by the token or provided in the request body
    And the request property "$.sponsor" is set to a valid sponsor number in E.164 format
    And the request property "$.caller" is set to a valid caller number in E.164 format
    And the request property "$.callee" is set to a valid callee number in E.164 format
    When the request "ClickToDialBegin" is sent
    Then the response status code is 500
    And the response header "Content-Type" is "application/json"
    And the response body complies with the OAS schema at "/components/schemas/ErrorInfo"
    And the response property "$.code" is "0000001"
    And the response property "$.description" is "Internal Service Error"