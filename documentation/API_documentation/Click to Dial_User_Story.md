# Click-to-Dial (CtD) API User Story

| **Item** | **Details** |
| ---- | ------- |
| ***Summary*** | As an application developer belonging to logistics and consulting services, I want to acquire the capability from a Communication Service Provider (CSP) through our enterprise's application server, to allow our corporate clients to initiate dual-call requests to mobiles or landlines via web, app, or CRM systems. This capability should enable a conversation between the two parties after the second call is connected, while ensuring that both the caller and callee's terminals only display the system access code, protecting the privacy of both parties' numbers. This is to ensure that our users can conduct high-quality voice services while their privacy is protected. |
| ***Roles, Actors and Scope*** | **Roles:** Customer:User<br> **Actors:** Application service providers, application developers.<br> **Scope:** 
(1) Click-to-Dial Initiation: The application uses this API, carrying key information such as the API key, subscription ID, platform number, caller's number, and callee's number. Upon receiving this API request, the communication capabilities open platform calls the outbound dual-party atomic capability. The Application Server (AS) uses the platform number to first call the caller. After the caller's terminal rings and the caller picks up, a click-to-dial prompt tone is played to the caller. Then, using the platform number, the callee is called. After the callee's terminal rings and the callee picks up, the click-to-dial prompt tone for the caller is stopped, establishing a call between the caller and callee.<br>  

(2)Click-to-Dial Call Status Notification: After the call is established, this API is used to send a status notification to the application, carrying information such as the session ID.<br> 

(3) Click-to-Dial Termination: The application calls this API, carrying information such as the session ID. Upon receiving this API request, the communication capabilities open platform calls the terminate outbound dual-party atomic capability. The Application Server (AS) releases the call created by the outbound dual-party atomic capability based on the session ID's indication.<br>

|
| ***Pre-conditions*** |TBD|
| ***Activities/Steps*** | **Starts when:** <br>**Ends when:**<br> TBD |
| ***Post-conditions*** | TBD  |
| ***Exceptions*** |  TBD  |

