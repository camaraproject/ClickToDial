# Changelog ClickToDial

<!-- TOC:START -->
## Table of Contents
- [r2.1](#r21)
<!-- TOC:END -->

**Please be aware that the project will have frequent updates to the main branch. There are no compatibility guarantees associated with code in any branch, including main, until it has been released. For example, changes may be reverted before a release is published. For the best results, use the latest published release.**

The below sections record the changes for each API version in each release as follows:

* for an alpha release, the delta with respect to the previous release
* for the first release-candidate, all changes since the last public release
* for subsequent release-candidate(s), only the delta to the previous release-candidate
* for a public release, the consolidated changes since the previous public release

# r2.1

## Release Notes

This release candidate contains the definition and documentation of
* click-to-dial 0.2.0-rc.1

The API definition(s) are based on
* Commonalities 0.8.0
* Identity and Consent Management 0.5.0

## click-to-dial 0.2.0-rc.1

**click-to-dial 0.2.0-rc.1 is a release-candidate version of this API.**

Changes documented below are compared to version 0.1.0.

- API definition **with inline documentation**:
  - [View it on ReDoc](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/camaraproject/ClickToDial/r2.1/code/API_definitions/click-to-dial.yaml&nocors)
  - [View it on Swagger Editor](https://camaraproject.github.io/swagger-ui/?url=https://raw.githubusercontent.com/camaraproject/ClickToDial/r2.1/code/API_definitions/click-to-dial.yaml)
  - OpenAPI [YAML spec file](https://github.com/camaraproject/ClickToDial/blob/r2.1/code/API_definitions/click-to-dial.yaml)

### Breaking changes

* N/A

### Added

* Added detailed ClickToDial call lifecycle documentation, clarifying the provider-managed aggregate call session state and the `initiating`, `callingCaller`, `callingCallee`, `connected`, `disconnected`, and `failed` status values.
* Added detailed user stories and acceptance criteria for creating ClickToDial calls with status notifications, terminating active calls, and retrieving recordings after completed recorded calls.
* Added enhanced Gherkin test scenarios for rainy-day and edge-case behavior across `createCall`, `getCall`, `terminateCall`, and `getRecording`, including malformed and unknown `callId`, authentication and authorization failures, invalid caller/callee inputs, recording availability, and callback event validation.

### Changed

* Clarified callback delivery behavior for status notifications, including structured CloudEvents delivery, `CallStatusChangedEvent` usage, sink credential handling, retry behavior, and state reconciliation using `GET /calls/{callId}`.
* Clarified recording availability conditions for `GET /calls/{callId}/recording`, including when a recording can be retrieved and when `404 NOT_FOUND` is returned.
* Improved OpenAPI descriptions for call status, callback events, call creation, and recording retrieval without changing API behavior.

### Fixed

* Fixed stale documentation and test references from `EventCTDStatusChanged` to the current `CallStatusChangedEvent` schema.
* Fixed Gherkin test expectations to align callback event `caller` and `callee` values with the phone number payload defined in the OpenAPI schema.
* Fixed recording retrieval test expectations to avoid requiring optional `generatedAt` in `RecordingResource`.
* Corrected supplementary API authentication guidance to use `private_key_jwt` client authentication and reference onboarding-defined authorization flows and operation-specific scopes.
* Aligned supplementary documentation and examples with the OpenAPI definition by documenting `recordingEnabled`, treating `datacontenttype` as optional, removing stale version information, and using valid reserved E.164 example numbers.

### Removed

* N/A

**Full Changelog**: https://github.com/camaraproject/ClickToDial/compare/r1.4...r2.1

