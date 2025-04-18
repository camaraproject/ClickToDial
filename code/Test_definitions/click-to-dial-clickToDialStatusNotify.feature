Feature: Click to Dial Service API Validations
    # Input to be provided by the implementation to the tester
    #
    # Implementation indications:
    # * apiRoot: API root of the server URL
    #
    # References to OAS spec schemas refer to schemas specified in Click to Dial.yaml, version 0.1.0

  Background: Common ClickToDialStatusNotify setup
    Given an environment at "apiRoot"       |
    And the header "Content-Type" is set to "application/json"
    And the header "Authorization" is set to a valid access token
        # Properties not explicitly overwitten in the Scenarios can take any values compliant with the schema
    And the request body is set by default to a request body compliant with the schema at "/components/schemas/ClickToDialStatusNotifyRequest"

    # Success scenarios
  @clicktodialstatusnotify_success
  Scenario: Common validations for ClickToDialStatusNotify success scenario
    Given a valid call identifier obtained from a previous ClickToDialBegin response
    And the request property "$.caller" is set to a valid caller number in E.164 format
    And the request property "$.callee" is set to a valid callee number in E.164 format
    And the request property "$.status" is set to a valid call status, for example "Connected"
    And the request property "$.timeStamp" is set to the current UTC time in ISO8601 format
    When the request "ClickToDialStatusNotify" is sent
    Then the response status code is 200

  @clicktodialstatusnotify_failure_missing_status
  Scenario: Fail to send status notification due to missing status field in ClickToDialStatusNotify request
    Given a valid call identifier obtained from a previous ClickToDialBegin response
    And the request property "$.caller" is set to a valid caller number in E.164 format
    And the request property "$.callee" is set to a valid callee number in E.164 format
    # The request is missing the "status" property
    And the request property "$.timeStamp" is set to the current UTC time in ISO8601 format
    When the request "ClickToDialStatusNotify" is sent
    Then the response status code is 400
    And the response header "Content-Type" is "application/json"
    And the response body complies with the OAS schema at "/components/schemas/ErrorInfo"
    And the response property "$.code" is "0000002"
    And the response property "$.description" is "Invalid Input Value"

  @clicktodialstatusnotify_failure_invalid_callidentifier
  Scenario: Fail to send status notification due to invalid call identifier in ClickToDialStatusNotify request
    Given an invalid call identifier
    And the request property "$.caller" is set to a valid caller number in E.164 format
    And the request property "$.callee" is set to a valid callee number in E.164 format
    And the request property "$.status" is set to a valid call status, for example "Connected"
    And the request property "$.timeStamp" is set to the current UTC time in ISO8601 format
    When the request "ClickToDialStatusNotify" is sent
    Then the response status code is 400
    And the response header "Content-Type" is "application/json"
    And the response body complies with the OAS schema at "/components/schemas/ErrorInfo"
    And the response property "$.code" is "1001002"
    And the response property "$.description" is "Call ID Error"

  @clicktodialstatusnotify_failure_server_error
  Scenario: Fail to send status notification due to server error in ClickToDialStatusNotify request
    Given a valid call identifier obtained from a previous ClickToDialBegin response
    And the request property "$.caller" is set to a valid caller number in E.164 format
    And the request property "$.callee" is set to a valid callee number in E.164 format
    And the request property "$.status" is set to a valid call status, for example "Connected"
    And the request property "$.timeStamp" is set to the current UTC time in ISO8601 format
    When the request "ClickToDialStatusNotify" is sent
    Then the response status code is 500
    And the response header "Content-Type" is "application/json"
    And the response body complies with the OAS schema at "/components/schemas/ErrorInfo"
    And the response property "$.code" is "0000001"
    And the response property "$.description" is "Internal Service Error"