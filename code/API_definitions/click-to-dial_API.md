# Overview

<span class="colour" style="color:rgb(0, 0, 0)">The Click to Dial  API refers to the ability of users to initiate a call request through an enterprise platform or application. The open platform receives the request and processes it, subsequently connecting both the calling and called parties. Once the parties answer the call, it enables point-to-point voice communication between them. </span> 

## 1\. Introduction


The Click to Dial API displays the enterprise business number to both users during the call to hide the numbers of both the calling and called parties, effectively protecting user privacy. Real-time feedback on call status assists in managing the call process for the enterprise. Enterprise members share a pool of minutes, with the enterprise bearing unified payment, eliminating issues such as exceeding limits or wasting leftover package resources, thus reducing costs and increasing efficiency for the enterprise.


## 2\. Quick Start

This chapter helps you quickly get started with the `Click to Dial Service API` to initiate, manage, and download call recordings.

### 2.1 Prerequisites
- **Authentication**: Obtain an OAuth 2.0 `access_token` using client credentials.
  
  ```bash
  curl -X POST "{tokenUrl}" -d "grant_type=client_credentials&client_id={your_id}&client_secret={your_secret}"
  ```

### 2.2 Quick Try
#### 2.2.1 Initiate a Call
- **Request**:
  ```bash
  curl -X POST "https://example.com/clicktodial/v1/clicktodialbegin" \
       -H "Authorization: Bearer {access_token}" \
       -H "Content-Type: application/json" \
       -d '{"sponsor": "01052680000", "caller": "12345678", "callee": "87654321"}'
  ```
- **Response**: Returns `callidentifier` (e.g., `"A010B020"`).

#### 2.2.2 Click to Dial status notify
- **Note**: Implement the server-side endpoint `/clicktodialstatusnotify/{callidentifier}` to receive status updates from the operator.

#### 2.2.3 Release a Call
- **Request**:
  
  ```bash
  curl -X POST "https://example.com/clicktodial/v1/clicktodialrelease/A010B020" \
       -H "Authorization: Bearer {access_token}" \
       -H "Content-Type: application/json" \
       -d '{"operation": "EndCall"}'
  ```

#### 2.2.4 Download Recording
- **Request**:
  
  ```bash
  curl -X POST "https://example.com/clicktodial/v1/recordingdownload/A010B020" \
       -H "Authorization: Bearer {access_token}" \
       -H "Content-Type: application/json" \
       -d '{"recordingId": "20230101120001"}'
  ```

### 2.3 Key Tips
- **Number Format**: Use E.164 (e.g., `12345678`).
- **Status Codes**: `200` for success, `400` for bad input, `403` for forbidden.
- **Debugging**: Check `code` and `description` in responses.

## 3\. Authentication and Authorization

**Client Credentials Grant (OAuth 2.0)**

The Client Credentials Grant is an OAuth 2.0 authorization flow used when a client (such as a server, backend service, or application) needs to authenticate and access resources without user involvement. This flow is commonly used for machine-to-machine (M2M) communication, such as microservices, APIs, or background jobs.

**How It Works**

The client (e.g., a backend application) requests an access token from the authorization server by sending its Client ID and Client Secret.

The authorization server verifies the client¡¯s credentials.

If authentication is successful, the authorization server responds with an access token.

The client uses the access token to make authorized API requests to access the protected resources.

## 4\. API Documentation
### 4.1 API Version

1.0.0

### 4.2 Details
#### 4.2.1 API sequencing

Click to Dial Business Process:

1.The enterprise contacts the account manager or orders online to activate the Click to Dial capability product and completes the addition/deletion of member numbers.

2.The enterprise application can initiate a call by calling the "Overview of Click to Dial Initiation Interface" interface, providing the calling user number and the called user number.

3.The capability platform responds and initiates calls to the calling and called user numbers.

4.(Optional) The enterprise application can cancel the current call by calling the "Overview of Click to Dial Termination Interface" interface.

5.The platform sends status reports to the enterprise application regarding the voice messages sent to users.

#### 4.2.1 API attributes 

1. **Click to Dial Initiation**

| **Name** | **Description**                                              | **Comment** |
| -------- | ------------------------------------------------------------ | ----------- |
| sponsor  | Platform number, typically a China Mobile fixed-line number, following the E.164 format. | Required.   |
| caller   | Calling party number, typically a mobile or fixed-line number from domestic carriers like China Mobile, China Telecom, China Unicom, etc., following the E.164 format. | Required.   |
| callee   | Called party number, typically a mobile or fixed-line number from domestic carriers like China Mobile, China Telecom, China Unicom, etc., following the E.164 format. | Required.   |

2. **Click to Dial status notify**

| **Name**        | **Description**                                              | **Comment**                                                  |
| --------------- | ------------------------------------------------------------ | ------------------------------------------------------------ |
| caller          | Calling party number.                                        | Required.                                                    |
| callee          | Called party number.                                         | Required.                                                    |
| status          | Call status.                                                 | Required. Possible values: CallingCaller, CallingCallee, Connected, Disconnected. |
| reason          | Reason for call disconnection. Required when status is Disconnected. | Required when status is Disconnected. Possible values: HangUp, CallerBusy, CallerNoAnswer, CallerFailure, CallerAbandon, CalleeBusy, CalleeNoAnswer, CalleeFailure, Other. |
| recordingResult | Recording status. Required when recording is enabled.        | Required when recording is enabled. Possible values: Success, NoRecord, Fail. |
| recordingId     | Recording file ID. Required when recording is enabled.       | Required when recording is enabled.                          |
| callDuration    | Duration of the call in seconds. Required when the call ends. | Required when the call ends.                                 |
| timeStamp       | Timestamp in UTC format. Required.                           | Required. Format: YYYY-MM-DDThh:mm:ss.SSSZ                   |

3. **Click to Dial release**

| **Name**  | **Description**    | **Comment**                                   |
| --------- | ------------------ | --------------------------------------------- |
| operation | Type of operation. | Required. Possible values: Continue, EndCall. |

4. **Recording download**

| **Name**    | **Description**           | **Comment** |
| ----------- | ------------------------- | ----------- |
| recordingId | ID of the recording file. | Required.   |

### 4.3 Endpoint Definitions

Following table defines API endpoints of exposed REST based for Click to dial API.

| **Endpoint**                                                 | **Operation**                   | **Description**                                              |
| ------------------------------------------------------------ | ------------------------------- | ------------------------------------------------------------ |
| POST   <base-url>https://example.com/clicktodial/v1/clicktodialbegin | **Click to Dial Initiation**    | Developer application calls click dial to initiate API and establish a call between the caller and the recipient |
| POST   <base-url>http://{appServer}/clicktodial/v1/<br />clicktodialstatusnotify/{callidentifier} | **Click to Dial status notify** | When the call status changes, the communication capability open platform reports the call status between the caller and the called to the developer application through the click dial call status notification API. |
| POST   <base-url>https://example.com/clicktodial/v1/clicktodialrelease/{callidentifier} | **Click to Dial release**       | The developer application calls the click dial termination API to end the call between the caller and the recipient. |
| POST   <base-url>https://example.com/clicktodial/v1/recordingdownload/{callidentifier} | **Download recording**          | Download the recording. Applications and platforms need to support HTTP long latency and long connections for file downloads. |

<br>

#### Click To Dial Resource Operation:

<br>

| **Click to Dial Initiation** |
| -------------------------- |
| **HTTP Request**<br> POST \<base-url>https://example.com/clicktodial/v1/clicktodialbegin

**Query Parameters**<br> No query parameters are defined.<br>**Path Parameters**<br>No Path Parameters are defined <br>**Request Body Parameters**<br> See above table for attribute definition.<br> Following attributes are mandatory in the request: sponsor,caller,callee;

No attributes are optional in the request;

 <br>**Response**

<br> **200: Click to Dial Initialed**<br>  Response body: 

| Name        | Description                                                  | Comment   |
| ----------- | ------------------------------------------------------------ | --------- |
| code        | Return code. The return code length is 7 digits.             | Required. |
| description | Description information of the return code                   | Required. |
| result      | Call result information.<br/>The detailed parameter requirements for CallResult are as follows. | Required. |

CallResult:

| Name           | Description         | Comment   |
| -------------- | ------------------- | --------- |
| callidentifier | Call identification | Required. |

<br> **400:** **Invalid input.**<br> **403:** **Forbidden.**<br> **500:** **Internal Service Error.**<br> **503:** **Gateway Timeout.** 

<br>

| **Click to Dial status notify** |
| -------------------------- |
| **HTTP Request**<br> POST \<base-url>http://{appServer}/clicktodial/v1/clicktodialstatusnotify/{callidentifier}

**Query Parameters**<br> No query parameters are defined.<br>**Path Parameters**<br>No Path Parameters are defined <br>**Request Body Parameters**<br> See above table for attribute definition.<br> Following attributes are mandatory in the request: caller,callee,status,reason,callDuration,timeStamp;

Following attributes are optional in the request:recordingResult,recordingId;

 <br>**Response**

<br> **200: Received notification**<br>  Response body: 

| Name        | Description                                      | Comment   |
| ----------- | ------------------------------------------------ | --------- |
| code        | Return code. The return code length is 7 digits. | Required. |
| description | Description information of the return code       | Required. |

<br> **400:** **Invalid input.**<br> **403:** **Forbidden.**<br> **500:** **Internal Service Error.**<br> **503:** **Gateway Timeout.** 



| **Click to Dial release** |
| -------------------------- |
| **HTTP Request**<br> POST \<base-url>https://example.com/clicktodial/v1/clicktodialrelease/{callidentifier}

**Query Parameters**<br> No query parameters are defined.<br>**Path Parameters**<br>No Path Parameters are defined <br>**Request Body Parameters**<br> See above table for attribute definition.<br> Following attributes are mandatory in the request: operation;

No attributes are optional in the request;

 <br>**Response**

<br> **200: Click to Dial released**<br>  Response body: 

| Name        | Description                                      | Comment   |
| ----------- | ------------------------------------------------ | --------- |
| code        | Return code. The return code length is 7 digits. | Required. |
| description | Description information of the return code       | Required. |

<br> **400:** **Invalid input.**<br> **403:** **Forbidden.**<br> **500:** **Internal Service Error.**<br> **503:** **Gateway Timeout.** 



| **Download recording** |
| -------------------------- |
| **HTTP Request**<br> POST \<base-url>https://example.com/clicktodial/v1/recordingdownload/{callidentifier}

**Query Parameters**<br> No query parameters are defined.<br>**Path Parameters**<br>No Path Parameters are defined <br>**Request Body Parameters**<br> See above table for attribute definition.<br> Following attributes are mandatory in the request: recordingId;

Following attributes are optional in the request:filedata;

 <br>**Response**

<br> **200: Recording download successful**<br>  Response body: 

| Name        | Description                                                  | Comment   |
| ----------- | ------------------------------------------------------------ | --------- |
| code        | Return code. The return code length is 7 digits.             | Required. |
| description | Description information of the return code                   | Required. |
| filedata    | Success must be accompanied by the content of the voice file.<br/>Encoding format is base64<br/>After extracting the file content, decode and store it | Optional. |

<br> **400:** **Invalid input.**<br> **403:** **Forbidden.**<br> **500:** **Internal Service Error.**<br> **503:** **Gateway Timeout.** 

### 4.4 Errors

| **No** | **Error Name** | **Error Code** | **Error Message**         |
| ------ | -------------- | -------------- | ------------------------- |
| 1      | 400            | 0000002        | "Invalid Input Value"     |
| 2      | 400            | 0001001        | "User Not Exist"          |
| 3      | 400            | 0001003        | "Password Error"          |
| 4      | 400            | 0001004        | "Authentication Failure"  |
| 5      | 400            | 0001008        | "User In Blacklist"       |
| 6      | 400            | 1001001        | "Number Format Error"     |
| 7      | 400            | 1001002        | "Call ID Error"           |
| 8      | 400            | 1001003        | "Operation Error"         |
| 9      | 400            | 1001004        | "Direction Error"         |
| 10     | 403            | 0001002        | "User Status Error"       |
| 11     | 403            | 0001002        | "Traffic Control Failure" |
| 12     | 500            | 0000001        | "Internal Service Error"  |
| 13     | 500            | 1000002        | "Engines Return Error"    |
| 14     | 504            | 1000001        | "Engine Timeout"          |

### 4.5 Policies

N/A

### 4.6 Code Snippets

|                                                              |
| ------------------------------------------------------------ |
| curl -X 'POST' `https://example.com/clicktodial/v1/clicktodialbegin`   <br/>    -H 'accept: application/json' <br/>    -H 'Content-Type: application/json'<br/>    -d '{<br/>"sponsor":"01052680000",<br/>"caller":"8613912345673",<br/>"callee":"8613810268653"  } |
| response will be: <br/> 200 <br/>   -d '{<br/>"code": "0000000",<br/>"description": "Success",<br/>"result": {<br/>		"callidentifier": "A010B020"<br/>}  }' |



### 4.7 FAQ's

FAQs will be added in a later version of the documentation)

### 4.8 Terms

N/A

### 4.9 Release Notes

0.1 Release note

- Added introduction

- Added status attribute in Error
- Added quick start
- Added authentication and authorization
- Added API Documentation

## References


N/A
