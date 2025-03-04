# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

### Fixed

### Changed

## [0.4.3] - 2025-03-04

### Migrating from 0.3.0: 
Please check notes for 0.4.1

### Changed
* Update Lakekeeper to Version `0.7.3`

## [0.4.2] - 2025-02-28

### Migrating from 0.3.0: 
Please check notes for 0.4.1

### Changed
* Update Lakekeeper to Version `0.7.2`

## [0.4.1] - 2025-02-26

### Migrating from 0.3.0: 

As we changed the pod-selectors of Lakekeeper's deployment according to Kubernetes [Recommended Labels](https://kubernetes.io/docs/concepts/overview/working-with-objects/common-labels/) (thanks @nlamirault), the deployment needs to be synced using the `--force` option.

### Changed
* Update Lakekeeper to Version `0.7.1`
* Improve values.yaml descriptions regarding PG encryption key
* Prevent postgres encryption secret being created if a secret is specified
* Better ArgoCD compatibility via Annotations for OpenFGA & DB migrate job to avoid deadlocks.
* Disable `helmWait` by default.
* Add hook annotations to DB migration independent of `helmWait` value. (except `helm-hook-enabled: false`)
* Update openfga sub-chart to `0.2.23`
* Update postgres sub-chart to `16.4.14`
* Support all Kubernetes recommended labels

## [0.4.0] - 2025-02-26
Non existant

## [0.3.2] - 2025-01-27

### Changed
* Update Lakekeeper to Version `0.6.2`

## [0.3.1] - 2025-01-27

### Changed
* Update Lakekeeper to Version `0.6.1`
* Update PostgreSQL to `16.4.5`
* Update OpenFGA to `0.2.21`

## [0.3.0] - 2025-01-17

### Changed
* Update Lakekeeper to Version `0.6.0`
* Update PostgreSQL to `16.4.3`


## [0.2.1] - 2024-12-17

### Added
* Update Lakekeeper to Version `0.5.2`

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
