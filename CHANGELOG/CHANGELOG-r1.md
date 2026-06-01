# Changelog ClickToDial

<!-- TOC:START -->
## Table of Contents
- **[r1.4](#r14)**
- [r1.3](#r13)
- [r1.2](#r12)
- [r1.1](#r11)
<!-- TOC:END -->

**Please be aware that the project will have frequent updates to the main branch. There are no compatibility guarantees associated with code in any branch, including main, until it has been released. For example, changes may be reverted before a release is published. For the best results, use the latest published release.**

The below sections record the changes for each API version in each release as follows:

* for an alpha release, the delta with respect to the previous release
* for the first release-candidate, all changes since the last public release
* for subsequent release-candidate(s), only the delta to the previous release-candidate
* for a public release, the consolidated changes since the previous public release

# r1.4

## Release Notes

This public release contains the definition and documentation of
* click-to-dial 0.1.0

The API definition(s) are based on
* Commonalities 0.8.0
* Identity and Consent Management 0.5.0

## click-to-dial 0.1.0

**click-to-dial 0.1.0 is the initial public version of the ClickToDial API.**

- API definition **with inline documentation**:
  - [View it on ReDoc](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/camaraproject/ClickToDial/r1.4/code/API_definitions/click-to-dial.yaml&nocors)
  - [View it on Swagger Editor](https://camaraproject.github.io/swagger-ui/?url=https://raw.githubusercontent.com/camaraproject/ClickToDial/r1.4/code/API_definitions/click-to-dial.yaml)
  - OpenAPI [YAML spec file](https://github.com/camaraproject/ClickToDial/blob/r1.4/code/API_definitions/click-to-dial.yaml)

### Added

* Added the initial public ClickToDial API definition with operations to create a call, retrieve call details, terminate a call, and retrieve call recordings when available.
* Added callback support for ClickToDial call status change notifications using the CAMARA CloudEvents-based event model.
* Added support for notification sink credentials aligned with the CAMARA event subscription model.
* Added Gherkin test definitions for the main ClickToDial operations, including create call, get call, terminate call, and get recording.
* Added API documentation and external API description content for public visibility.

### Changed

* Aligned the ClickToDial API definition with Commonalities r4.3 / `0.8.0`.
* Aligned the ClickToDial API definition with Identity and Consent Management r4.2 / `0.5.0`.
* Updated the API to use a CAMARA-compliant RESTful call resource model under `/calls`.
* Updated CAMARA error response schemas and common reusable components to follow the applicable Commonalities model.
* Updated callback notification security and callback response documentation.
* Updated the ClickToDial event model to use the Commonalities CloudEvents envelope while retaining the ClickToDial-specific event type and payload.
* Replaced the ClickToDial-specific `CALL_ALREADY_ACTIVE` 409 error code with the Commonalities-aligned `ALREADY_EXISTS` code.
* Updated schema naming and validation constraints to comply with CAMARA validation rules.
* Updated request-body documentation and schema constraints to align with Commonalities r4.3 request body strictness requirements.

### Fixed

* Fixed CAMARA validation findings so the API definition validates with zero errors and zero warnings.
* Fixed authorization header usage in test definitions.
* Fixed x-correlator handling and resource URLs in test definitions.
* Fixed callback secured-operation response documentation by adding required error responses.

### Removed

* Removed obsolete local wrapper schemas now referenced directly from Commonalities artifacts.

**Full Changelog**: https://github.com/camaraproject/ClickToDial/compare/r1.1...r1.4

# r1.3

## Release Notes

This release candidate contains the definition and documentation of
* click-to-dial 0.1.0-rc.2

The API definition(s) are based on
* Commonalities 0.8.0-rc.2
* Identity and Consent Management 0.5.0

## click-to-dial 0.1.0-rc.2

**click-to-dial 0.1.0-rc.2 is the second release candidate of the click-to-dial API.**

- API definition **with inline documentation**:
  - [View it on ReDoc](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/camaraproject/ClickToDial/r1.3/code/API_definitions/click-to-dial.yaml&nocors)
  - [View it on Swagger Editor](https://camaraproject.github.io/swagger-ui/?url=https://raw.githubusercontent.com/camaraproject/ClickToDial/r1.3/code/API_definitions/click-to-dial.yaml)
  - OpenAPI [YAML spec file](https://github.com/camaraproject/ClickToDial/blob/r1.3/code/API_definitions/click-to-dial.yaml)

### Added

* Added callback security documentation for ClickToDial status notifications using `notificationsBearerAuth`.
* Added Commonalities r4.2 synchronized common artifacts under `code/common`, including `.sync-manifest.yaml`.

### Changed

* Aligned the ClickToDial API definition with Commonalities r4.2 / `0.8.0-rc.2`.
* Aligned the ClickToDial API definition with Identity and Consent Management r4.2 / `0.5.0`.
* Updated CAMARA error response schemas to follow the Commonalities r4.2 `ErrorInfo` response template.
* Updated ClickToDial status change callback events to use the Commonalities r4.2 CloudEvents envelope while keeping the ClickToDial-specific event type and payload.
* Replaced the ClickToDial-specific `CALL_ALREADY_ACTIVE` 409 error code with the Commonalities-aligned `ALREADY_EXISTS` code.
* Aligned reusable schemas such as phone number, sink credentials, x-correlator, timestamps, and notification-related schemas with Commonalities r4.2.
* Renamed local OAS schema components to PascalCase without changing JSON property names or API wire format.

### Fixed

* Fixed callback response documentation by adding secured-operation error responses for notification delivery.
* Fixed CAMARA Validation findings so the API definition validates with zero errors and zero warnings.

### Removed

* Removed obsolete local wrapper schemas that are now referenced directly from Commonalities r4.2 artifacts.

**Full Changelog**: https://github.com/camaraproject/ClickToDial/compare/r1.2...r1.3

# r1.2

## Release Notes

This release candidate contains the definition and documentation of
* click-to-dial 0.1.0-rc.1

The API definition(s) are based on
* Commonalities v0.7.0-rc.1
* Identity and Consent Management v0.5.0-rc.1

## click-to-dial 0.1.0-rc.1

**click-to-dial 0.1.0-rc.1 is a pre-release version of the click-to-dial API**

- API definition **with inline documentation**:
  - [View it on ReDoc](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/camaraproject/ClickToDial/r1.2/code/API_definitions/click-to-dial.yaml&nocors)
  - [View it on Swagger Editor](https://camaraproject.github.io/swagger-ui/?url=https://raw.githubusercontent.com/camaraproject/ClickToDial/r1.2/code/API_definitions/click-to-dial.yaml)
  - OpenAPI [YAML spec file](https://github.com/camaraproject/ClickToDial/blob/r1.2/code/API_definitions/click-to-dial.yaml)

### Added

* Introduced the fully RESTful `/calls` resource model:  
  * `POST /calls`
  * `GET /calls/{callId}`
  * `DELETE /calls/{callId}`
  * `GET /calls/{callId}/recording`
* CloudEvents-based call status change notifications:
  * type: `org.camaraproject.click-to-dial.v0.status-changed`
  * specversion: "1.0"
* Structured `422 UnprocessableEntity` business validation error codes:
  * `INVALID_PHONE_NUMBER`
  * `SAME_CALLER_CALLEE`
  * `RECORDING_NOT_SUPPORTED`
  * `CALLER_NOT_AVAILABLE`
  * `CALLEE_NOT_AVAILABLE`

### Changed

* Enum values aligned with CAMARA lowerCamelCase conventions for status and reason.
* Updated sink credential schema to enforce `credentialType = "ACCESSTOKEN"`.
* Updated BDD test definitions to reflect the `/calls` endpoints and versioned base paths.
* Improved alignment of OpenAPI definitions and markdown API documentation examples.

### Fixed

* Corrected CloudEvent examples to match defined schemas and enum values.
* Resolved inconsistencies between error examples and the `ErrorInfo` schema.

### Removed

* Removed deprecated operations from earlier alpha versions:
  * `beginCall`
  * `releaseCall`
  * `downloadRecording`
  
  These have been replaced by the RESTful `/calls` design.

### New Contributors

- N/A

**Full Changelog**: https://github.com/camaraproject/ClickToDial/compare/r1.1...r1.2

# r1.1

## Release Note

This release contains the definition and documentation of

- click-to-dial v0.1.0-alpha.1

The API definition(s) are based on

- Commonalities v0.5.0
- Identity and Consent Management v0.3.0

## click-to-dial v0.1.0-alpha.1

click-to-dial v0.1.0-alpha.1 is the first pre-release version of the click-to-dial API.

- API definition **with inline documentation**:
  - [View it on ReDoc](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/camaraproject/ClickToDial/r1.1/code/API_definitions/click-to-dial.yaml&nocors)
  - [View it on Swagger Editor](https://camaraproject.github.io/swagger-ui/?url=https://raw.githubusercontent.com/camaraproject/ClickToDial/r1.1/code/API_definitions/click-to-dial.yaml)
  - OpenAPI [YAML spec file](https://github.com/camaraproject/ClickToDial/blob/r1.1/code/API_definitions/click-to-dial.yaml)

## Added

- Update for fall2025 by @YadingFang in [#22](https://github.com/camaraproject/ClickToDial/pull/22), [#27](https://github.com/camaraproject/ClickToDial/pull/27), [#29](https://github.com/camaraproject/ClickToDial/pull/29), [#31](https://github.com/camaraproject/ClickToDial/pull/31), [#32](https://github.com/camaraproject/ClickToDial/pull/32)
- Create Click to Dial_API.md by @wuhonglin in [#9](https://github.com/camaraproject/ClickToDial/pull/9)
- Add Click to Dial support material by @HanbaiWang  in [#6](https://github.com/camaraproject/ClickToDial/pull/6)
- Create Click to Dial_User_Story by @seekwain in [#11](https://github.com/camaraproject/ClickToDial/pull/11)
- Add API yaml files by @seekwain in [#10](https://github.com/camaraproject/ClickToDial/pull/10)
- Create Click to Dial_API.md by @wuhonglin in [#9](https://github.com/camaraproject/ClickToDial/pull/9)
- Add CTD support material by @HanbaiWang  in [#6](https://github.com/camaraproject/ClickToDial/pull/6)

## Changed

- N/A

## Fixed

- N/A

## Removed

- N/A

## New Contributors

- @HanbaiWang made their first contribution in [#4](https://github.com/camaraproject/ClickToDial/pull/4)
- @wuhonglin made their first contribution in [#9](https://github.com/camaraproject/ClickToDial/pull/9)
- @seekwain made their first contribution in [#10](https://github.com/camaraproject/ClickToDial/pull/10)
- @YadingFang make their first contribution in [#22](https://github.com/camaraproject/ClickToDial/pull/22)

**Full Changelog**: [https://github.com/camaraproject/ClickToDial/commits/r1.1/](https://github.com/camaraproject/ClickToDial/commits/r1.1/)

