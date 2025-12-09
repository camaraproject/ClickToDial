Feature: CAMARA Click to Dial API, vwip - Operation recordingDownload
    # Input to be provided by the implementation to the tester
    #
    # Implementation indications:
    # * apiRoot: API root of the server URL
    #
    # References to OAS spec schemas refer to schemas specified in click-to-dial.yaml

  Background: Common recordingDownload setup
    Given an environment at "apiRoot"       |
    And the header "Content-Type" is set to "application/json"
    And the header "Authorization" is set to a valid access token
        # Properties not explicitly overwitten in the Scenarios can take any values compliant with the schema
    And the request body is set by default to a request body compliant with the schema at "/components/schemas/RecordingDownloadRequest"

    # Success scenarios
  @recordingDownload_success
  Scenario: Common validations for recordingDownload success scenario
    Given a valid call identifier obtained from a previous ClickToDialBegin response
    And the request property "$.recordingId" is set to a valid recording identifier
    When the request "recordingDownload" is sent
    Then the response status code is 200
    And the response header "Content-Type" is "application/json"
    # The response has to comply with the OAS schema for recordingDownloadResponse
    And the response body complies with the OAS schema at "/components/schemas/recordingDownloadResponse"
    And the response property "$.code" is "0000000"
    And the response property "$.description" is "Success"
    And the response property "$.result" exists

  @recordingDownload_failure_missing_recordingId
  Scenario: Fail to download recording due to missing recordingId in recordingDownload request
    Given a valid call identifier obtained from a previous ClickToDialBegin response
    # The request is missing the "recordingId" property
    When the request "recordingDownload" is sent
    Then the response status code is 400
    And the response header "Content-Type" is "application/json"
    And the response body complies with the OAS schema at "/components/schemas/ErrorInfo"
    And the response property "$.code" is "0000002"
    And the response property "$.description" is "Invalid Input Value"

  @recordingDownload_failure_authentication
  Scenario: Fail to download recording due to authentication failure in recordingDownload request
    Given an invalid or missing authentication token for the service
    And the request property "$.recordingId" is set to a valid recording identifier
    When the request "recordingDownload" is sent
    Then the response status code is 400
    And the response header "Content-Type" is "application/json"
    And the response body complies with the OAS schema at "/components/schemas/ErrorInfo"
    And the response property "$.code" is "0001004"
    And the response property "$.description" is "Authentication Failure"

  @recordingDownload_failure_invalid_callidentifier
  Scenario: Fail to download recording due to invalid call identifier in recordingDownload request
    Given an invalid call identifier
    And the request property "$.recordingId" is set to a valid recording identifier
    When the request "recordingDownload" is sent
    Then the response status code is 400
    And the response header "Content-Type" is "application/json"
    And the response body complies with the OAS schema at "/components/schemas/ErrorInfo"
    And the response property "$.code" is "1001002"
    And the response property "$.description" is "Call ID Error"

  @recordingDownload_failure_server_error
  Scenario: Fail to download recording due to server error in recordingDownload request
    Given a valid call identifier obtained from a previous ClickToDialBegin response
    And the request property "$.recordingId" is set to a valid recording identifier
    When the request "recordingDownload" is sent
    Then the response status code is 500
    And the response header "Content-Type" is "application/json"
    And the response body complies with the OAS schema at "/components/schemas/ErrorInfo"
    And the response property "$.code" is "0000001"
    And the response property "$.description" is "Internal Service Error"