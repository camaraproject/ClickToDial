Feature: CAMARA Click to Dial API, v0.2.0-rc.1 - Operation createCall
    # Input to be provided by the implementation to the tester
    #
    # Implementation indications:
    # * apiRoot: API root of the server URL
    #
    # References to OAS spec schemas refer to schemas specified in click-to-dial.yaml

  Background: Common createCall setup
    Given an environment at "apiRoot"
    And the resource "/click-to-dial/v0.2rc1/calls"
    And the header "Content-Type" is set to "application/json"
    And the header "Authorization" is set to a valid access token
    And the header "x-correlator" is set to a valid UUID
    And the header "x-correlator" complies with the schema at "#/components/schemas/XCorrelator"
    # Properties not explicitly overwritten in the Scenarios can take any values compliant with the schema
    And the request body is set by default to a request body compliant with the schema at "/components/schemas/CreateCallRequest"

    # Success scenarios

  @createcall_success
  Scenario: Common validations for createCall success scenario
    Given the request property "$.caller" is set to a valid caller number in E.164 format
    And the request property "$.callee" is set to a valid callee number in E.164 format
    When the request "createCall" is sent
    Then the response status code is 201
    And the response header "Content-Type" is "application/json"
    # The response has to comply with the OAS schema for Call
    And the response body complies with the OAS schema at "/components/schemas/Call"
    And the response property "$.callId" exists
    And the response property "$.caller" has the same value as createCall request property "$.caller"
    And the response property "$.callee" has the same value as createCall request property "$.callee"

  @createcall_event_notification
  Scenario: Events are received when sink and access token credential are provided
    Given the request property "$.caller" is set to a valid caller number in E.164 format
    And the request property "$.callee" is set to a valid callee number in E.164 format
    And the request property "$.sink" is set to a URL where events can be monitored
    And the request property "$.sinkCredential.credentialType" is set to "ACCESSTOKEN"
    And the request property "$.sinkCredential.accessTokenType" is set to "bearer"
    And the request property "$.sinkCredential.accessToken" is set to a valid access token accepted by the events receiver
    And the request property "$.sinkCredential.accessTokenExpiresUtc" is set to a future RFC3339 timestamp
    When the request "createCall" is sent
    Then the response status code is 201
    And an event is received at the address of the request property "$.sink"
    And the event header "Authorization" is set to "Bearer " + the value of the request property "$.sinkCredential.accessToken"
    And the event header "Content-Type" is "application/cloudevents+json"
    And the event body complies with the OAS schema at "#/components/schemas/CallStatusChangedEvent"

  @createcall_event_notification
  Scenario: Event body fields follow ClickToDial status rules
    Given the request property "$.caller" is set to a valid caller number in E.164 format
    And the request property "$.callee" is set to a valid callee number in E.164 format
    And the request property "$.sink" is set to a URL where events can be monitored
    And the request property "$.sinkCredential.credentialType" is set to "ACCESSTOKEN"
    And the request property "$.sinkCredential.accessTokenType" is set to "bearer"
    And the request property "$.sinkCredential.accessToken" is set to a valid access token accepted by the events receiver
    And the request property "$.sinkCredential.accessTokenExpiresUtc" is set to a future RFC3339 timestamp
    When the request "createCall" is sent
    And an event is received at the address of the request property "$.sink"
    Then the event body fields follow the ClickToDial status rules
      | path                   | rule                                                                                   |
      | $.id                   | unique per event                                                                       |
      | $.type                 | = "org.camaraproject.click-to-dial.v0.status-changed"                                  |
      | $.data.callId          | = createCall response property "$.callId"                                              |
      | $.data.caller          | = createCall request property "$.caller.number"                                        |
      | $.data.callee          | = createCall request property "$.callee.number"                                        |
      | $.data.status.state    | in [initiating, callingCaller, callingCallee, connected, disconnected, failed]         |
      | $.data.status.reason   | present iff state="disconnected" and in [hangUp, callerBusy, callerNoAnswer, callerFailure, callerAbandon, calleeBusy, calleeNoAnswer, calleeFailure, other] |
      | $.data.recordingResult | optional; if present, in [success, noRecord, fail]                                     |
      | $.data.callDuration    | present iff state="disconnected"                                                       |
      | $.data.timestamp       | time of state change                                                                   |

  @createcall_failure_missing_caller
  Scenario: Fail to initiate call due to missing caller in createCall request
    Given the request property "$.caller" is removed from the request body
    And the request property "$.callee" is set to a valid callee number in E.164 format
    When the request "createCall" is sent
    Then the response status code is 400
    And the response header "Content-Type" is "application/json"
    And the response body complies with the OAS schema at "/components/schemas/ErrorInfo"
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"

  @createcall_failure_missing_callee
  Scenario: Fail to initiate call due to missing callee in createCall request
    Given the request property "$.caller" is set to a valid caller number in E.164 format
    And the request property "$.callee" is removed from the request body
    When the request "createCall" is sent
    Then the response status code is 400
    And the response header "Content-Type" is "application/json"
    And the response body complies with the OAS schema at "/components/schemas/ErrorInfo"
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"

  @createcall_failure_authentication
  Scenario: Fail to initiate call due to authentication failure in createCall request
    Given an invalid or missing authentication token for the service
    And the request property "$.caller" is set to a valid caller number in E.164 format
    And the request property "$.callee" is set to a valid callee number in E.164 format
    When the request "createCall" is sent
    Then the response status code is 401
    And the response header "Content-Type" is "application/json"
    And the response body complies with the OAS schema at "/components/schemas/ErrorInfo"
    And the response property "$.status" is 401
    And the response property "$.code" is "UNAUTHENTICATED"

  @createcall_failure_invalid_caller
  Scenario: Fail to initiate call due to invalid caller number format in createCall request
    Given the request property "$.caller.number" is set to an invalid phone number (not in E.164 format)
    And the request property "$.callee" is set to a valid callee number in E.164 format
    When the request "createCall" is sent
    Then the response status code is 422
    And the response header "Content-Type" is "application/json"
    And the response body complies with the OAS schema at "/components/schemas/ErrorInfo"
    And the response property "$.status" is 422
    And the response property "$.code" is "INVALID_PHONE_NUMBER"

  @createcall_failure_invalid_callee
  Scenario: Fail to initiate call due to invalid callee number format in createCall request
    Given the request property "$.caller" is set to a valid caller number in E.164 format
    And the request property "$.callee.number" is set to an invalid phone number (not in E.164 format)
    When the request "createCall" is sent
    Then the response status code is 422
    And the response header "Content-Type" is "application/json"
    And the response body complies with the OAS schema at "/components/schemas/ErrorInfo"
    And the response property "$.status" is 422
    And the response property "$.code" is "INVALID_PHONE_NUMBER"

  @createcall_failure_same_caller_callee
  Scenario: Fail to initiate call when caller and callee numbers are the same
    Given the request property "$.caller.number" is set to "+447700900000"
    And the request property "$.callee.number" is set to "+447700900000"
    When the request "createCall" is sent
    Then the response status code is 422
    And the response header "Content-Type" is "application/json"
    And the response body complies with the OAS schema at "/components/schemas/ErrorInfo"
    And the response property "$.status" is 422
    And the response property "$.code" is "SAME_CALLER_CALLEE"

  @createcall_failure_unknown_property
  Scenario: Fail to initiate call due to unknown additional property in request body
    Given the request property "$.unknownProperty" is set to "someValue"
    And the request property "$.caller" is set to a valid caller number in E.164 format
    And the request property "$.callee" is set to a valid callee number in E.164 format
    When the request "createCall" is sent
    Then the response status code is 400
    And the response header "Content-Type" is "application/json"
    And the response body complies with the OAS schema at "/components/schemas/ErrorInfo"
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"

  @createcall_failure_recording_not_supported
  Scenario: Fail to initiate call when recording is requested but not supported
    Given the request property "$.caller" is set to a valid caller number in E.164 format
    And the request property "$.callee" is set to a valid callee number in E.164 format
    And the request property "$.recordingEnabled" is set to true
    And recording is not supported for the requested call
    When the request "createCall" is sent
    Then the response status code is 422
    And the response header "Content-Type" is "application/json"
    And the response body complies with the OAS schema at "/components/schemas/ErrorInfo"
    And the response property "$.status" is 422
    And the response property "$.code" is "RECORDING_NOT_SUPPORTED"

  @createcall_failure_caller_not_available
  Scenario: Fail to initiate call when the caller is not available
    Given the request property "$.caller" is set to a valid caller number in E.164 format
    And the caller number is not available or not allowed to start a call
    And the request property "$.callee" is set to a valid callee number in E.164 format
    When the request "createCall" is sent
    Then the response status code is 422
    And the response header "Content-Type" is "application/json"
    And the response body complies with the OAS schema at "/components/schemas/ErrorInfo"
    And the response property "$.status" is 422
    And the response property "$.code" is "CALLER_NOT_AVAILABLE"

  @createcall_failure_callee_not_available
  Scenario: Fail to initiate call when the callee is not available
    Given the request property "$.caller" is set to a valid caller number in E.164 format
    And the request property "$.callee" is set to a valid callee number in E.164 format
    And the callee number is not available or not allowed to receive a call
    When the request "createCall" is sent
    Then the response status code is 422
    And the response header "Content-Type" is "application/json"
    And the response body complies with the OAS schema at "/components/schemas/ErrorInfo"
    And the response property "$.status" is 422
    And the response property "$.code" is "CALLEE_NOT_AVAILABLE"

  @createcall_failure_invalid_sink
  Scenario: Fail to initiate call due to invalid sink URI
    Given the request property "$.caller" is set to a valid caller number in E.164 format
    And the request property "$.callee" is set to a valid callee number in E.164 format
    And the request property "$.sink" is set to an invalid URI
    When the request "createCall" is sent
    Then the response status code is 400
    And the response header "Content-Type" is "application/json"
    And the response body complies with the OAS schema at "/components/schemas/ErrorInfo"
    And the response property "$.status" is 400
    And the response property "$.code" is "INVALID_ARGUMENT"
