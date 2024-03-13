# Overview

<span class="colour" style="color:rgb(0, 0, 0)">The Click to Dial  API refers to the ability of users to initiate a call request through an enterprise platform or application. The open platform receives the request and processes it, subsequently connecting both the calling and called parties. Once the parties answer the call, it enables point-to-point voice communication between them. </span> 

## 1\. Introduction


The Click to Dial API displays the enterprise business number to both users during the call to hide the numbers of both the calling and called parties, effectively protecting user privacy. Real-time feedback on call status assists in managing the call process for the enterprise. Enterprise members share a pool of minutes, with the enterprise bearing unified payment, eliminating issues such as exceeding limits or wasting leftover package resources, thus reducing costs and increasing efficiency for the enterprise.


## 2\. Quick Start

Using the  API involves three main steps: business activation, business utilization, and customer service.

**Business processing**
The business processing capabilities of Click to Dial include five parts: business handling, business modification, business cancellation, business suspension/resumption.

1.Intention to Subscribe

[Customer] Enterprise customers can submit their intention to subscribe through the China Mobile Communication Capability Open Platform portal or by calling the Government and Enterprise Customer Service hotline at 10086-8:

(1) Portal Method for Communication Capability Open Platform:

a. User Registration: Enterprise customers visit the Communication Capability Open Platform portal at http://ct.open.10086.cn to submit account, phone number, email, and other information, completing registration.
b. Account Activation: After registration, the contact person's email will receive an activation email, and enterprise customers activate the account as per the email instructions.
c. Submit Intention to Subscribe: Enterprise customers use their username and password to log in to the Communication Capability Open Platform, and reserve business opportunities in the console - User Center - Authentication Center.

(2) Government and Enterprise Customer Service Hotline: Enterprise customers call the Government and Enterprise Customer Service hotline at 10086-8 to submit their intention to subscribe.

[Customer] Customer Data Preparation: Enterprise customers need to prepare relevant enterprise information, including enterprise certificates, the name of the legal representative, the ID number of the legal representative, photos of the legal representative's ID card (front and back), legal representative's mobile phone, name of the handler, handler's ID number, photos of the handler's ID card (front and back), handler's email, handler's mobile phone, and other related information.

2.Business Activation

[Account Manager] Customer Engagement: After the business opportunity reservation is approved, an account manager from the customer's region will engage with the enterprise customer, and the enterprise customer submits relevant enterprise information to the account manager.

[Account Manager] Enterprise Qualification Review: The account manager conducts enterprise qualification authentication and review based on the enterprise data.

[Account Manager] Completion of Business Activation: After approval, the account manager completes the business activation for the enterprise customer, including establishing customer data, subscribing to basic communication capability open products, completing the application for short service code bureau data, ordering capability products (or enterprise customers can order through the portal), ordering service codes (or enterprise customers can order through the portal), completing business activation, and archiving work orders.

[Customer] Completion of Number Ordering: During the subscription process of the Click to Dial capability product, number ordering needs to be completed for the business to function properly.

(1) [Customer] Online: Enterprise customers can order the numbers required for their business needs through the Communication Capability Open Platform. The platform reviews the number ordering application submitted by enterprise customers and completes the number ordering after approval.

(2) [Account Manager] Offline: Enterprise customers can order the numbers required for their business needs through the account manager at the service hall. The account manager selects the numbers, and the Communication Capability Open Platform reviews the number ordering application submitted by the customer. After approval, the number ordering is completed.

3.Business Modification, Cancellation, Suspension/Resumption

[Customer] Enterprise customers can log in to the China Mobile Communication Capability Open Platform or contact their account manager to request business modification, cancellation, or suspension/resumption.

**Business utilization**

1.Obtaining API Key
Enterprise customers log in to the China Mobile Communication Capability Open Platform at http://ct.open.10086.cn, create an application, or add the Click to Dial capability to an existing application, and obtain the API key.

2.Enterprise Application Development
Enterprise customers conduct API integration development based on the Click to Dial capability interface documentation available on the China Mobile Communication Capability Open Platform portal. The interface documentation can be obtained from the portal page - Development Documents - Click to Dial.

3.Enterprise Application Deployment
Enterprise customers complete application development, conduct functional testing, and then deploy the application for use by the enterprise's end users.

**Customer service**

1.Group customers can seek assistance for business inquiries and fault reporting through their account manager, provincial customer service hotline 10086-8, or the Government and Enterprise Customer Service hotline 4001100868, which operates 24/7.

2.The Click to Dial service ensures continuous customer support during critical security periods. During important festivals, second and third-tier customer service representatives are available for 24/7 phone duty, and in the event of emergencies, they provide feedback to vendors for resolution within 30 minutes.

## 3\. Authentication and Authorization


The Click to Dial API utilizes Basic authentication, with the value being Basic {credential}. The {credential} is a Base64-encoded string in the format "appId:Secretkey", where ":" is a half-width colon.
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

| **Name**      | **Description**                                              | **Comment**                 |
| ------------- | ------------------------------------------------------------ | --------------------------- |
| Authorization | Authentication information provided in the request header. Value is in Basic {credential} format, where {credential} is a Base64 encoded string in the format "appId:Secretkey". Colon is a half-width symbol. | Required in request header. |
| APPID         | Application ID.                                              | Required.                   |
| sponsor       | Platform number, typically a China Mobile fixed-line number, following the E.164 format. | Required.                   |
| caller        | Calling party number, typically a mobile or fixed-line number from domestic carriers like China Mobile, China Telecom, China Unicom, etc., following the E.164 format. | Required.                   |
| callee        | Called party number, typically a mobile or fixed-line number from domestic carriers like China Mobile, China Telecom, China Unicom, etc., following the E.164 format. | Required.                   |
| record        | Indicates whether the call is recorded or not. Possible values: 0 (No), 1 (Yes). | Optional.                   |
| sendDirection | Specifies the destination for sending multimedia messages (MMS). Default is not to enable MMS. Possible values: MO (Mobile Originated), MT (Mobile Terminated), BOTH (Mobile Originated and Terminated). | Optional.                   |

2. **Click to Dial status notify**

| **Name**        | **Description**                                              | **Comment**                                                  |
| --------------- | ------------------------------------------------------------ | ------------------------------------------------------------ |
| Authorization   | Authorization information provided in the request header. Value is in Basic {credential} format, where {credential} is a Base64 encoded string in the format "appId:Secretkey". Colon is a half-width symbol. | Required in request header.                                  |
| APPID           | Application ID.                                              | Required.                                                    |
| caller          | Calling party number.                                        | Required.                                                    |
| callee          | Called party number.                                         | Required.                                                    |
| status          | Call status.                                                 | Required. Possible values: CallingCaller, CallingCallee, Connected, Disconnected. |
| reason          | Reason for call disconnection. Required when status is Disconnected. | Required when status is Disconnected. Possible values: HangUp, CallerBusy, CallerNoAnswer, CallerFailure, CallerAbandon, CalleeBusy, CalleeNoAnswer, CalleeFailure, Other. |
| recordingResult | Recording status. Required when recording is enabled.        | Required when recording is enabled. Possible values: Success, NoRecord, Fail. |
| recordingId     | Recording file ID. Required when recording is enabled.       | Required when recording is enabled.                          |
| callDuration    | Duration of the call in seconds. Required when the call ends. | Required when the call ends.                                 |
| timeStamp       | Timestamp in UTC format. Required.                           | Required. Format: YYYY-MM-DDThh:mm:ss.SSSZ                   |

3. **Click to Dial release**

| **Name**      | **Description**                                              | **Comment**                                   |
| ------------- | ------------------------------------------------------------ | --------------------------------------------- |
| Authorization | Authorization information provided in the request header. Value is in Basic {credential} format, where {credential} is a Base64 encoded string in the format "appId:Secretkey". Colon is a half-width symbol. | Required in request header.                   |
| APPID         | Application ID.                                              | Required.                                     |
| operation     | Type of operation.                                           | Required. Possible values: Continue, EndCall. |

4. **Recording download**

| **Name**      | **Description**                                              | **Comment**                     |
| ------------- | ------------------------------------------------------------ | ------------------------------- |
| Authorization | Authentication information provided in the request header. The value is in the Basic {credential} format, where {credential} is a Base64-encoded string in the format "appId:Secretkey". The colon is a half-width symbol. | Required in the request header. |
| APPID         | Application ID.                                              | Required.                       |
| recordingId   | ID of the recording file.                                    | Required.                       |

### 4.3 Endpoint Definitions

Following table defines API endpoints of exposed REST based for Click to dial API.

| **Endpoint**                                                 | **Operation**                   | **Description**                                              |
| ------------------------------------------------------------ | ------------------------------- | ------------------------------------------------------------ |
| POST   <base-url>http://ct.open.10086.cn/clicktodial/v1/clicktodialbegin | **Click to Dial Initiation**    | Developer application calls click dial to initiate API and establish a call between the caller and the recipient |
| POST   <base-url>http://{appServer}/clicktodial/v1/<br />clicktodialstatusnotify/{callidentifier} | **Click to Dial status notify** | When the call status changes, the communication capability open platform reports the call status between the caller and the called to the developer application through the click dial call status notification API. |
| POST   <base-url>http://ct.open.10086.cn/clicktodial/v1/clicktodialrelease/{callidentifier} | **Click to Dial release**       | The developer application calls the click dial termination API to end the call between the caller and the recipient. |
| POST   <base-url>http://ct.open.10086.cn/clicktodial/v1/recordingdownload/{callidentifier} | **Download recording**          | Download the recording. Applications and platforms need to support HTTP long latency and long connections for file downloads. |

<br>

#### Click To Dial Resource Operation:

<br>

| **Click to Dial Initiation** |
| -------------------------- |
| **HTTP Request**<br> POST \<base-url>http://ct.open.10086.cn/clicktodial/v1/clicktodialbegin

**Query Parameters**<br> No query parameters are defined.<br>**Path Parameters**<br>No Path Parameters are defined <br>**Request Body Parameters**<br> See above table for attribute definition.<br> Following attributes are mandatory in the request: Authorization,APPID,sponsor,caller,callee;

Following attributes are optional in the request:record,sendDirection;

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

<br> **400:** **Invalid input.**<br> **401:** **Un-authorized.** <br> **403:** **Forbidden.**<br> **500:** **Server Error.**<br> **503:** **Service temporarily unavailable.** 

<br>

| **Click to Dial status notify** |
| -------------------------- |
| **HTTP Request**<br> POST \<base-url>http://{appServer}/clicktodial/v1/clicktodialstatusnotify/{callidentifier}

**Query Parameters**<br> No query parameters are defined.<br>**Path Parameters**<br>No Path Parameters are defined <br>**Request Body Parameters**<br> See above table for attribute definition.<br> Following attributes are mandatory in the request: Authorization,APPID,sponsor,caller,callee,status;

Following attributes are optional in the request:record,sendDirection;

 <br>**Response**

<br> **200: Received notification**<br>  Response body: 

| Name        | Description                                      | Comment   |
| ----------- | ------------------------------------------------ | --------- |
| code        | Return code. The return code length is 7 digits. | Required. |
| description | Description information of the return code       | Required. |

<br> **400:** **Invalid input.**<br> **401:** **Un-authorized.** <br> **403:** **Forbidden.**<br> **500:** **Server Error.**<br> **503:** **Service temporarily unavailable.** 



| **Click to Dial release** |
| -------------------------- |
| **HTTP Request**<br> POST \<base-url>http://ct.open.10086.cn/clicktodial/v1/clicktodialrelease/{callidentifier}

**Query Parameters**<br> No query parameters are defined.<br>**Path Parameters**<br>No Path Parameters are defined <br>**Request Body Parameters**<br> See above table for attribute definition.<br> Following attributes are mandatory in the request: Authorization,APPID,operation;

No attributes are optional in the request;

 <br>**Response**

<br> **200: Click to Dial released**<br>  Response body: 

| Name        | Description                                      | Comment   |
| ----------- | ------------------------------------------------ | --------- |
| code        | Return code. The return code length is 7 digits. | Required. |
| description | Description information of the return code       | Required. |

<br> **400:** **Invalid input.**<br> **401:** **Un-authorized.** <br> **403:** **Forbidden.**<br> **500:** **Server Error.**<br> **503:** **Service temporarily unavailable.** 



| **Download recording** |
| -------------------------- |
| **HTTP Request**<br> POST \<base-url>http://ct.open.10086.cn/clicktodial/v1/recordingdownload/{callidentifier}

**Query Parameters**<br> No query parameters are defined.<br>**Path Parameters**<br>No Path Parameters are defined <br>**Request Body Parameters**<br> See above table for attribute definition.<br> Following attributes are mandatory in the request: Authorization,APPID,recordingId;

No attributes are optional in the request:filedata;

 <br>**Response**

<br> **200: Recording download successful**<br>  Response body: 

| Name        | Description                                                  | Comment   |
| ----------- | ------------------------------------------------------------ | --------- |
| code        | Return code. The return code length is 7 digits.             | Required. |
| description | Description information of the return code                   | Required. |
| filedata    | Success must be accompanied by the content of the voice file.<br/>Encoding format is base64<br/>After extracting the file content, decode and store it | Optional. |

<br> **400:** **Invalid input.**<br> **401:** **Un-authorized.** <br> **403:** **Forbidden.**<br> **500:** **Server Error.**<br> **503:** **Service temporarily unavailable.** 

### 4.4 Errors

| No   | Error Name | Error Code | Error Message                               |
| ---- | ---------- | ---------- | ------------------------------------------- |
| 1    | 400        | 0001001    | "Expected property is missing: APPID"       |
| 2    | 400        | 0001001    | "Expected property is missing: sponsor"     |
| 3    | 400        | 0001001    | "Expected property is missing: caller"      |
| 4    | 400        | 0001001    | "Expected property is missing: callee"      |
| 5    | 400        | 0001001    | "Expected property is missing: recordingId" |
| 6    | 401        | 0001002    | "No authorization to invoke operation"      |
| 7    | 403        | 0001003    | "Customer status abnormality"               |
| 8    | 403        | 0001004    | "Abnormal application status"               |
| 9    | 403        | 0001005    | "Message length is too long"                |
| 11   | 500        | 0000001    | "Internal Service Error"                    |
| 12   | 503        | 0000002    | "Service unavailable"                       |

### 4.5 Policies

N/A

### 4.6 Code Snippets

|                                                              |
| ------------------------------------------------------------ |
| curl -X 'POST' `http://ct.open.10086.cn/clicktodial/v1/clicktodialbegin`   <br/>    -H 'accept: application/json' <br/>    -H 'Content-Type: application/json'<br/>    -H "Authorization: Basic 2ZQsweeFFJS1zCsicMspWD...."<br/>    -d '{<br/>"APPID":"12345678",<br/>"sponsor":"01052680000",<br/>"caller":"8613912345673",<br/>"callee":"8613810268653"  } |
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
