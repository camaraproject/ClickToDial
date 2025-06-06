# Changelog ClickToDial

## Table of Contents

- [r1.2](#r12)
- [r1.1](#r11)

**Please be aware that the project will have frequent updates to the main branch. There are no compatibility guarantees associated with code in any branch, including main, until it has been released. For example, changes may be reverted before a release is published. For the best results, use the latest published release.**

The below sections record the changes for each API version in each release as follows:

- for an alpha release, the delta with respect to the previous release
- for the first release-candidate, all changes since the last public release
- for subsequent release-candidate(s), only the delta to the previous release-candidate
- for a public release, the consolidated changes since the previous public release

# r1.2

## Release Note

This release contains the definition and documentation of

- click-to-dial v0.1.0-rc.1

The API definition(s) are based on

- Commonalities v0.5.0
- Identity and Consent Management v0.3.0

## click-to-dial v0.1.0-rc.1

click-to-dial v0.1.0-rc.1 is the 1st release candidate version of the version 0.1.0.
- API definition **with inline documentation**:
  - [View it on ReDoc](https://redocly.github.io/redoc/?url=https://raw.githubusercontent.com/camaraproject/ClickToDial/r1.2/code/API_definitions/click-to-dial.yaml&nocors)
  - [View it on Swagger Editor](https://editor.swagger.io/?url=https://raw.githubusercontent.com/camaraproject/ClickToDial/r1.2/code/API_definitions/click-to-dial.yaml)
  - OpenAPI [YAML spec file](https://github.com/camaraproject/ClickToDial/blob/r1.2/code/API_definitions/click-to-dial.yaml)

## Added

- Add API rpository wiki page link in README.md by @YadingFang in [#39](https://github.com/camaraproject/ClickToDial/pull/39)
- Add testing content for the notification interface in click-to-dial-clickToDialBegin.feature by @YadingFang in [#46](https://github.com/camaraproject/ClickToDial/pull/46)

## Changed

- Update README.md according latest template by @YadingFang in [#39](https://github.com/camaraproject/ClickToDial/pull/39)
- Embed click-to-dial_API.md into the API definition by @YadingFang in [#42](https://github.com/camaraproject/ClickToDial/pull/42)
- Remove the API name in the endpoints by @YadingFang in [#43](https://github.com/camaraproject/ClickToDial/pull/43)

## Fixed

- Change ClickToDialStatusNotifyRequest to EventCTDStatusChanged, and associate it with CloudEvent via discriminator by @YadingFang in [#46](https://github.com/camaraproject/ClickToDial/pull/46)
- Add the callIdentifier parameter to the notification interface by @YadingFang in [#46](https://github.com/camaraproject/ClickToDial/pull/46)

## Removed

- Remove the recordingId field by @YadingFang in [#46](https://github.com/camaraproject/ClickToDial/pull/46)
- Remove click-to-dial-clickToDialStatusNotify.feature by @YadingFang in [#46](https://github.com/camaraproject/ClickToDial/pull/46)

**Full Changelog**: https://github.com/camaraproject/QualityOnDemand/compare/r1.1...r1.2

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
  - [View it on Swagger Editor](https://editor.swagger.io/?url=https://raw.githubusercontent.com/camaraproject/ClickToDial/r1.1/code/API_definitions/click-to-dial.yaml)
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
