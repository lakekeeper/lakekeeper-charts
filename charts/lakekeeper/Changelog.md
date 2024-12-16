# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

### Fixed
* Deployment under root-path "/" with built-in ingress
* `externalDatabase.userSecret` was not beeing used
* `auth.oauth2.ui.scopes` had no effect

### Changed


## [0.2.0] - 2024-12-09

### Added
* `audience`, `additionalIssuers` and `ui` for `auth.oauth2`
* Kubernetes Authentication (`auth.k8s`) including a ClusterRoleBinding to validate tokens
* Authorization configuration `authz`
* Dependency on OpenFGA HelmChart if `internalOpenFGA` is true
* Bootstrapping Test

### Fixed

### Changed
* Upgrade Lakekeeper to Version `0.5.1`
* Upgrade Postgres dependency to `16.2.5`
* Renamed `auth.oauth2.client_id` to `auth.oauth2.audience`
* Renamed `auth.oauth2.provider_uri` to `auth.oauth2.providerUri`


## [0.1.5] - 2024-11-13

### Fixed
* `extraEnv` are added twice
* Bump Lakekeeper to Version 0.4.3 - Fixes a bug where remote signing is not working with AWS S3


## [0.1.4] - 2024-10-28

### Fixed
Bump Lakekeeper to Version 0.4.2 - Azure performance improvements & Support for self-signed S3 certificates

## [0.1.3] - 2024-10-23

### Fixed
Fixed `extraVolumeMounts` not attached to migrate job

## [0.1.2] - 2024-10-15

### Changed
Bump Lakekeeper to Version 0.4.1 - GCP fixes

## [0.1.0] - 2024-10-04

Initial Release with Version 0.4.0 migrated from the tip-catalog charts!
