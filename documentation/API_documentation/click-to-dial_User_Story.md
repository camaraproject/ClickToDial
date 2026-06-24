# Click-to-Dial (CTD) API User Story

| **Item**                    | **Details**                                                                                                                                                                                                                                                                                                                                                                                          |
| --------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Summary**                 | As an application developer, I want to allow API consumers to initiate Click-to-Dial call sessions via the provider API so that two parties (caller and callee) can be connected via a voice call. The API should support call creation, termination, optional recording, and asynchronous status notifications. |
| **Roles, Actors and Scope** | **Roles:** API consumer; **Actors:** Application developers, integration engineers, CSP (service provider); **Scope:** Create and remove CTD session resources (calls), receive status notifications and retrieve recordings when available.                                                                                                                                          |
| **Pre-conditions**          | The client application has been onboarded and is authorized to call the API (has a valid access token with required scopes); the client knows the `apiRoot` and can send HTTP requests; if event delivery is required, the client provides a reachable `sink` URL and optional `sinkCredential`.                                                                                                     |
| **Activities / Steps**      | Start: Client calls `POST /calls` with `caller`, `callee` and optional `sink`/`sinkCredential`. Flow: Provider places calls to both parties and manages the session; Provider delivers status notifications as CloudEvents to the configured `sink`. End: Client calls `DELETE /calls/{callId}` or session ends normally (call disconnected).                                                |
| **Post-conditions**         | Call session resource exists with a `callId` and lifecycle `status`; if `sink` was provided, the provider sends CloudEvents (structured mode) to the `sink` with updates about call state changes; when recording is enabled and the call completes, a recording resource may be available at `GET /calls/{callId}/recording`.                                                                   |
| **Exceptions**              | Authentication/authorization failure (401/403); invalid request body or parameters (400/422); conflicting state when trying to terminate (409); event delivery failures to the `sink` (provider may retry or record failures).                                                                                                                                                                           |

## Key implementation details (aligning with API spec)

- Endpoint naming and behaviour

  - `POST /calls` — create a new CTD call session. Success returns `201 Created` with a `Call` resource body containing `callId`, `caller`, `callee`, `status`, `createdAt`, etc.
  - `DELETE /calls/{callId}` — terminate an active call. Returns `204 No Content` when successful.
  - `GET /calls/{callId}` — retrieve call details.
  - `GET /calls/{callId}/recording` — retrieve recording resource when available.
- Request and response shapes

  - The `CreateCallRequest` expects `caller` and `callee` objects (each with `number` in E.164 format). Optional `sink` (URI) and `sinkCredential` may be provided. Example:

```json
{
  "caller": { "number": "+441234567890" },
  "callee": { "number": "+441234567891" },
  "sink": "https://example.com/sink",
  "sinkCredential": {
    "credentialType": "ACCESSTOKEN",
    "accessToken": "ya29.A0AR...",
    "accessTokenExpiresUtc": "2026-01-01T00:00:00Z",
    "accessTokenType": "bearer"
  },
  "recordingEnabled": true
}
```

- `SinkCredential` and authentication

  - The SinkCredential is a discriminator-based object defined by CAMARA Commonalities. The currently defined credential types include ACCESSTOKEN and PRIVATE_KEY_JWT. When ACCESSTOKEN is used, the concrete AccessTokenCredential MUST include `accessToken`, `accessTokenExpiresUtc` and `accessTokenType`.
  - When `sinkCredential` is provided, the provider will use the credential to authenticate HTTP requests to the `sink` when delivering events. The provider should set the `Authorization` header (e.g., `Authorization: Bearer <accessToken>`) when posting events.
- CloudEvents and notifications

  - Providers MUST deliver status notifications as CloudEvents in structured mode (`Content-Type: application/cloudevents+json`).
  - The CloudEvent MUST include `id`, `source`, `type`, `specversion`, `time`, and `datacontenttype`. `datacontenttype` for our events is `application/json`.
  - The event `data` payload for `CallStatusChangedEvent` contains `callId`, `caller`, `callee`, `timestamp` and `status` (an object):

```json
"status": {
  "state": "disconnected",
  "reason": "hangUp"
}
```

- `status.state` values: `initiating`, `callingCaller`, `callingCallee`, `connected`, `disconnected`, `failed`.
- `status.reason` is present only when `status.state` is `disconnected` and must be one of the documented disconnection reasons.

## Detailed Use Cases

### Use Case 1: Create ClickToDial call with status notifications

* **Goal**: An API consumer application initiates a voice call between a caller and a callee, and requests asynchronous status updates about the call session.
* **Pre-conditions**:
  * The application has obtained an OIDC access token with the scope `click-to-dial:calls:create`.
  * The application has set up a reachable endpoint (`sink` URL) capable of receiving HTTP POST requests.
* **Steps**:
  1. The API consumer calls `POST /calls` with the `caller` and `callee` numbers, the `sink` URL, and the corresponding `sinkCredential` of type `ACCESSTOKEN`.
  2. The provider validates the request (numbers are correct, format is E.164, etc.).
  3. The provider returns `201 Created` with the call details, including a unique `callId` and `status` set to `initiating`.
  4. The provider begins establishing the call and sends a sequence of CloudEvents in structured mode (`Content-Type: application/cloudevents+json`) using the `CallStatusChangedEvent` format to the `sink` URL, authenticating using the provided token as `Authorization: Bearer <accessToken>`.
  5. The status transitions through `callingCaller`, `callingCallee`, and finally `connected` when both parties answer.
* **Acceptance Criteria**:
  * The HTTP response returns `201 Created` with a valid callId compliant with the CallId schema and `status` object.
  * The provider sends structured CloudEvents with correct headers and schema.
  * Callback delivery failures do not roll back the call setup session.
  * The API consumer can query `GET /calls/{callId}` to reconcile the state.

### Use Case 2: Terminate an active ClickToDial call

* **Goal**: An API consumer application terminates an active call session.
* **Pre-conditions**:
  * An active ClickToDial call session is currently in progress (state is `callingCaller`, `callingCallee`, or `connected`).
  * The application has obtained an OIDC access token with the scope `click-to-dial:calls:delete`.
* **Steps**:
  1. The API consumer calls `DELETE /calls/{callId}` using the call's unique identifier.
  2. The provider terminates the active voice session and releases network resources.
  3. The provider returns `204 No Content`.
  4. The provider sends a final `CallStatusChangedEvent` with state `disconnected` and reason `hangUp` (or other appropriate reason) to the configured `sink` URL.
* **Acceptance Criteria**:
  * The API response is `204 No Content`.
  * Any subsequent `GET /calls/{callId}` returns details with status `disconnected`.
  * A final status notification is sent with `disconnected` state.

### Use Case 3: Retrieve recording after a completed recorded call

* **Goal**: An API consumer application retrieves the audio recording of a completed call session.
* **Pre-conditions**:
  * The ClickToDial call was created with `recordingEnabled` set to `true`.
  * The call session has ended and reached a final state (`disconnected` or `failed`).
  * The provider supports recording and a recording file was successfully generated.
  * The application has obtained an OIDC access token with the scope `click-to-dial:recordings:read`.
* **Steps**:
  1. The call ends, and the provider sends the final `CallStatusChangedEvent` containing `recordingResult: success`.
  2. The API consumer calls `GET /calls/{callId}/recording`.
  3. The provider returns `200 OK` with the base64 encoded audio content and correct MIME type.
* **Acceptance Criteria**:
  * If the call final event reports `recordingResult` as `success`, the recording must be accessible.
  * `GET /calls/{callId}/recording` returns `200 OK` with the base64 encoded audio byte content.
  * If recording is not available (e.g. `recordingResult: noRecord` or call is still active), the API returns `404 Not Found` with the code `NOT_FOUND`.

## Example end-to-end

1. Client POSTs to `/calls` with `caller`, `callee`, optional `sink`/`sinkCredential` and `recordingEnabled: true`.
2. Provider returns `201 Created` with call details including `callId`.
3. Provider sends CloudEvents to `sink` as the call progresses with call status updates.
4. When the call ends, the provider sends a final status event. If recording was requested, the event can include recordingResult, such as success, noRecord, or fail.
5. If recordingResult indicates success, the client can call GET /calls/{callId}/recording to download the recording resource.
