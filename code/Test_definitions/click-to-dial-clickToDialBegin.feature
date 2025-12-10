Feature: CAMARA Click to Dial API, vwip - Operation clickToDialBegin
    # Input to be provided by the implementation to the tester
    #
    # Implementation indications:
    # * apiRoot: API root of the server URL
    #
    # References to OAS spec schemas refer to schemas specified in click-to-dial.yaml

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

  @clicktodialbegin_event_notification
  Scenario: Events are received after a QoS session change if sink is provided
    # Valid testing device and default request body compliant with the schema
    Given a valid testing device supported by the service, identified by the token or provided in the request body
    And the request property "$.caller" is set to a valid caller number in E.164 format
    And the request property "$.callee" is set to a valid callee number in E.164 format
    And the request property "$.sink" is set to a URL where events can be monitored
    And the request property "$.sinkCredentials.credentialType" is set to "ACCESSTOKEN"
    And the request property "$.sinkCredentials.accessTokenType" is set to "bearer"
    And the request property "$.sinkCredentials.accessToken" is set to a valid access token accepted by the events receiver
    When the request "ClickToDialBegin" is sent
    Then the response status code is 200
    # There is no specific limit defined for the process to end
    And an event is received at the address of the request property "$.sink"
    And the event header "Authorization" is set to "Bearer: " + the value of the request property "$.sinkCredentials.accessToken"
    And the event header "Content-Type" is set to "application/cloudevents+json"
    And the event body complies with the OAS schema at "#/components/schemas/EventCTDStatusChanged"
    # Additionally any event body has to comply with some constraints beyond the schema compliance
    And the event body property "$.id" is unique
    And the event body property "$.type" is set to "org.camaraproject.click-to-dial.v0.status-changed"
    And the event body property "$.data.callidentifier" has the same value as ClickToDialBegin response property "$.result.callidentifier"
    And the event body property "$.data.caller" has the same value as ClickToDialBegin request property "$.caller"
    And the event body property "$.data.callee" has the same value as ClickToDialBegin request property "$.callee"
    And the event body property "$.data.status" is "CallingCaller" or "CallingCallee" or "Connected" or "Disconnected"
    And the event body property "$.data.reason" is exists only if "$.data.status" is "Disconnected" and the value is "HangUp" or "CallerBusy" or "CallerNoAnswer" or "CallerFailure" or "CallerAbandon" or "CalleeBusy" or "CalleeNoAnswer" or "CalleeFailure" or "Other"
    And the event body property "$.data.recordingResult" is "Success" or "NoRecord" or "Fail"
    And the event body property "$.data.callDuration" exists only if "$.data.status" is "Disconnected"
    And the event body property "$.data.timeStamp" is set to the time of state change

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