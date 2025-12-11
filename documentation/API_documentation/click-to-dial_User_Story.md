# Click-to-Dial (CTD) API User Story

| **Item**                    | **Details**                                                                                                                                                                                                                                                                                                                                                                                          |
| --------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Summary**                 | As an application developer for enterprise clients, I want to allow our corporate customers to initiate Click-to-Dial call sessions via the provider API so that two parties (caller and callee) are connected by masked numbers and can converse while the platform protects their privacy. The API should support call creation, termination, optional recording, and asynchronous status notifications. |
| **Roles, Actors and Scope** | **Roles:** Customer / User; **Actors:** Application developers, integration engineers, CSP (service provider); **Scope:** Create and remove CTD session resources (calls), receive status notifications and retrieve recordings when available.                                                                                                                                          |
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

  - `SinkCredential` is a discriminator object. Currently the only supported `credentialType` is `ACCESSTOKEN` and the concrete `AccessTokenCredential` MUST include `accessToken`, `accessTokenExpiresUtc` and `accessTokenType`.
  - When `sinkCredential` is provided, the provider will use the credential to authenticate HTTP requests to the `sink` when delivering events. The provider should set the `Authorization` header (e.g., `Authorization: Bearer <accessToken>`) when posting events.
- CloudEvents and notifications

  - Providers MUST deliver status notifications as CloudEvents in structured mode (`Content-Type: application/cloudevents+json`).
  - The CloudEvent MUST include `id`, `source`, `type`, `specversion`, `time`, `datacontenttype` and `subject` (subject should identify the resource, e.g. `/calls/{callId}`). `datacontenttype` for our events is `application/json`.
  - The event `data` payload for `EventCTDStatusChanged` contains `callId`, `caller`, `callee`, `timestamp` and `status` (an object):

```json
"status": {
  "state": "disconnected",
  "reason": "hangUp"
}
```

- `status.state` values: `initiating`, `callingCaller`, `callingCallee`, `connected`, `disconnected`, `failed`.
- `status.reason` is present only when `status.state` is `disconnected` and must be one of the documented disconnection reasons.

## Example end-to-end

1. Client POSTs to `/calls` with `caller`, `callee`, optional `sink`/`sinkCredential`.
2. Provider returns `201 Created` with call details including `callId`.
3. Provider sends CloudEvents to `sink` as the call progresses; each event's `subject` is `/calls/{callId}`.
4. When the call ends, provider sends a final `disconnected` state event including `callDuration` and, if recording was enabled, `recordingResult`.
5. Client can `GET /calls/{callId}/recording` to download the recording resource if available.
