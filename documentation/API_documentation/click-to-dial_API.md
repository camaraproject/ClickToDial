# Overview

The Click to Dial API allows users to initiate and manage calls via an enterprise platform or application. The API processes call requests, sets up the call, and provides optional notifications and call recording features.

## 1\. Introduction

 The API displays the enterprise business number to both users during a call, masking both the caller and callee’s real numbers to preserve privacy. Real-time feedback and notifications are supported via HTTP callbacks. Enterprise members share a pool of minutes, with the enterprise bearing unified payment, eliminating issues such as exceeding limits or wasting leftover package resources, thus reducing costs and increasing efficiency for the enterprise.

## 2\. Quick Start

### 2.1 Prerequisites

- **Authentication**: Obtain an OpenID Connect access token from your API provider.

  ```bash
  curl -X POST "{openid_token_url}" -d "grant_type=client_credentials&client_id={your_id}&client_secret={your_secret}"
  ```

### 2.2 Quick Try

#### 2.2.1 Initiate a Call

```bash
curl -X POST "{apiRoot}/begin" \
     -H "Authorization: Bearer {access_token}" \
     -H "Content-Type: application/json" \
     -d '{
      "caller": "+12345678", 
      "callee": "+87654321"，
      "sink": "https://yourapp.example.com/clicktodialstatusnotify",
      "sinkCredential": {
        "credentialType": "ACCESSTOKEN",
        "accessToken": "{sink_access_token}",
        "accessTokenExpiresUtc": "2025-12-31T23:59:59Z",
        "accessTokenType": "bearer"
      }
    }'
```

- **Response:**

```json
{
  "code": "0000000",
  "description": "Success",
  "result": {
    "callidentifier": "A010B020"
  }
}
```

#### 2.2.2 Status Notification Callback

- Implement an HTTP POST endpoint at your provided `sink` URL to receive status notifications. Example payloads are provided in the OpenAPI spec.

#### 2.2.3 Release a Call

```bash
  curl -X DELETE "{apiRoot}/release/A010B020" \
       -H "Authorization: Bearer {access_token}" \
```

**Response:**
HTTP 200 OK (no response body)

#### 2.2.4 Download Recording

```bash
curl -X GET "{apiRoot}/recording-download/A010B020" \
     -H "Authorization: Bearer {access_token}" \
```

**Response:**

```json
{
  "code": "0000000",
  "description": "Success",
  "filedata": "BASE64_ENCODED_AUDIO"
}
```

### 2.3 Key Tips

- **Number Format:** All phone numbers (caller, callee) must be in E.164 format, e.g., "+12345678".
- **Authentication:** Use OpenID Connect; include your access token as a Bearer token.
- **Status Codes:** 200 = success, 400 = bad input, 403 = forbidden, 401 = unauthorized.
- **Debugging:** Error responses include a code and description/message.

## 3\. Authentication and Authorization

This API uses **OpenID Connect** for authentication and authorization. Obtain your access token from your provider and use it in the Authorization header for all API requests.

## 4\. API Documentation

### 4.1 API Version

wip

### 4.2 Details

#### 4.2.1 API sequencing

1. Client calls **POST /begin** to start a call.
2. Server initiates calls to both caller and callee.
3. (Optional) Client may call **DELETE /release/{callidentifier}** to end a call.
4. Status notifications are sent via HTTP POST to the provided `sink` URL.

#### 4.2.1 API attributes

##### Click to Dial Initiation Request

| Name           | Description                                         | Required | Example                      |
| -------------- | --------------------------------------------------- | -------- | ---------------------------- |
| caller         | Calling party number (E.164, with "+")              | Yes      | "+12345678"                  |
| callee         | Called party number (E.164, with "+")               | Yes      | "+87654321"                  |
| sink           | (Optional) Callback URL for status notifications    | No       | "<https://yourapp.com/notify>" |
| sinkCredential | (Optional) Callback authentication info (see below) | No       | (see below)                  |

##### sinkCredential (for ACCESSTOKEN type)

| Name                  | Description               | Required | Example                |
| --------------------- | ------------------------- | -------- | ---------------------- |
| credentialType        | Must be "ACCESSTOKEN"     | Yes      | "ACCESSTOKEN"          |
| accessToken           | Access token for callback | Yes      | "sink_token"           |
| accessTokenExpiresUtc | UTC expiry timestamp      | Yes      | "2025-12-31T23:59:59Z" |
| accessTokenType       | Must be "bearer"          | Yes      | "bearer"               |

##### Click to Dial Status Notify (callback payload)

| Name            | Description                                      | Required | Notes/Values                       |
| --------------- | ------------------------------------------------ | -------- | ---------------------------------- |
| caller          | Calling party number (E.164)                     | Yes      |                                    |
| callee          | Called party number (E.164)                      | Yes      |                                    |
| status          | Call status                                      | Yes      | CallingCaller, CallingCallee, etc. |
| reason          | Disconnection reason (if status is Disconnected) | Cond.    | HangUp, CallerBusy, ...            |
| recordingResult | Recording status (if recording enabled)          | Cond.    | Success, NoRecord, Fail            |
| recordingId     | Recording ID (if recording enabled)              | Cond.    |                                    |
| callDuration    | Duration (sec, if call ended)                    | Cond.    |                                    |
| timeStamp       | UTC timestamp                                    | Yes      | RFC 3339 format                    |

#### Release Call

- Call identifier is provided as a path parameter in DELETE /release/{callidentifier}.

#### Recording Download

- Call identifier as path parameter in GET /recording-download/{callidentifier}.

### 4.3 Endpoint Definitions

| Endpoint                             | Method | Description                        |
| ------------------------------------ | ------ | ---------------------------------- |
| /begin                               | POST   | Start a click-to-dial call         |
| /release/{callidentifier}            | DELETE | End (release) a click-to-dial call |
| /recording-download/{callidentifier} | GET    | Download call recording            |

### 4.4 Errors

Errors follow the standard format:

```json
{
  "status": 400,
  "code": "INVALID_ARGUMENT",
  "message": "Client specified an invalid argument, request body or query param."
}
```

Reference the [OpenAPI YAML](../code/API_definitions/click-to-dial.yaml) for exact error codes and descriptions.

### 4.5 Policies

N/A

### 4.6 Example Code Snippets

#### Start a Call

```bash
curl -X POST "{apiRoot}/begin" \
  -H "Authorization: Bearer {access_token}" \
  -H "Content-Type: application/json" \
  -d '{
    "caller": "+12345678",
    "callee": "+87654321",
    "sink": "https://yourapp.example.com/clicktodialstatusnotify",
    "sinkCredential": {
      "credentialType": "ACCESSTOKEN",
      "accessToken": "{sink_access_token}",
      "accessTokenExpiresUtc": "2025-12-31T23:59:59Z",
      "accessTokenType": "bearer"
    }
  }'
```

#### Release a Call

```bash
curl -X DELETE "{apiRoot}/release/A010B020" \
  -H "Authorization: Bearer {access_token}"
```

#### Download a Recording

```bash
curl -X GET "{apiRoot}/recording-download/A010B020" \
  -H "Authorization: Bearer {access_token}"
```

### 4.7 FAQ's

To be added in future versions.

### 4.8 Terms

N/A

### 4.9 Release Notes

This section lists release notes for historical versions.
The current version on the main branch is **wip**.

- **0.1.0-alpha.1** — Initial release (archived).

## References

For a full API schema, see [code/API_definitions/click-to-dial.yaml](../../code/API_definitions/click-to-dial.yaml).
