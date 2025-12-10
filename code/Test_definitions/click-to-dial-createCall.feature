Feature: CAMARA Click to Dial API, vwip - Operation createCall
    # Input to be provided by the implementation to the tester
    #
    # Implementation indications:
    # * apiRoot: API root of the server URL
    #
    # References to OAS spec schemas refer to schemas specified in click-to-dial.yaml

  Background: Common createCall setup
    Given an environment at "apiRoot"       |
    And the header "Content-Type" is set to "application/json"
    And the header "Authorization" is set to a valid access token
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
    And the event body complies with the OAS schema at "#/components/schemas/EventCTDStatusChanged"
    # Additional constraints beyond schema compliance
    And the event body property "$.id" is unique
    And the event body property "$.type" is set to "org.camaraproject.click-to-dial.v0.status-changed"
    And the event body property "$.data.callId" has the same value as createCall response property "$.callId"
    And the event body property "$.data.caller" has the same value as createCall request property "$.caller"
    And the event body property "$.data.callee" has the same value as createCall request property "$.callee"
    And the event body property "$.data.status.state" is "initiating" or "callingCaller" or "callingCallee" or "connected" or "disconnected" or "failed"
    And the event body property "$.data.status.reason" exists only if "$.data.status.state" is "disconnected" and the value is "hangUp" or "callerBusy" or "callerNoAnswer" or "callerFailure" or "callerAbandon" or "calleeBusy" or "calleeNoAnswer" or "calleeFailure" or "other"
    And the event body property "$.data.recordingResult" is "success" or "noRecord" or "fail" if present
    And the event body property "$.data.callDuration" exists only if "$.data.status.state" is "disconnected"
    And the event body property "$.data.timestamp" is set to the time of state change

  @createcall_failure_missing_fields
  Scenario: Fail to initiate call due to missing required fields in createCall request
    And the request property "$.caller" is removed from the request body
    And the request property "$.callee" is set to a valid callee number in E.164 format
    When the request "createCall" is sent
    Then the response status code is 400
    And the response header "Content-Type" is "application/json"
    And the response body complies with the OAS schema at "/components/schemas/ErrorInfo"
    And the response property "$.status" is 400

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

  @createcall_failure_invalid_caller
  Scenario: Fail to initiate call due to invalid caller number format in createCall request
    And the request property "$.caller" is set to an invalid caller number (not E.164)
    And the request property "$.callee" is set to a valid callee number in E.164 format
    When the request "createCall" is sent
    Then the response status code is 422
    And the response header "Content-Type" is "application/json"
    And the response body complies with the OAS schema at "/components/schemas/ErrorInfo"
    And the response property "$.status" is 422
