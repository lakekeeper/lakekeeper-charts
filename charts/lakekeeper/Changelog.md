# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Changed

### Added
* Expose Metrics Port 9000 for Catalog Pods
* Add boolean `catalog.prometheus.setScrapeAnnotations` configuration option to set prometheus scrape labels
* Bump Lakekeeper image to 0.10.0
* Migrate away from the Bitnami chart

### Fixed

## [0.7.1] - 2025-08-15

### Changed
* Update Lakekeeper to v0.9.5
* Update Postgres Chart to 16.7.26
* Switch to Lakekeeper copies of bitnami images for postgressql to avoid breaking deployments when bitnami removes all tags but the `latest` as part of their [Secure Image initiative](https://news.broadcom.com/app-dev/broadcom-introduces-bitnami-secure-images-for-production-ready-containerized-applications). Check the README for more information.

### Added
* Expose Metrics Port 9000 for Catalog Pods
* Add boolean `catalog.prometheus.setScrapeAnnotations` configuration option to set prometheus scrape labels

## [0.7.0] - 2025-07-03

### Changed
* Update Lakekeeper to v0.9.2
* Change order of initContainers: `extraInitContainers` now precede the DB-Check
* Update OpenFGA Chart to v0.2.35 / Application to v1.8.16
* Update Postgres to 16.7.15

### Added
* Add option to set Kubernetes Authentication Audience

### Fixed
* Correctly mount "extraContainers" in the 

## [0.6.0] - 2025-05-09

### Fixed
* Volume mounting in the database migration job pod
* Downgrade OpenFGA to 0.8.6 due to a [knwon bug](https://github.com/lakekeeper/lakekeeper/issues/1068) in Version 0.8.11

### Changed
* Upgrade Lakekeeper to Version 0.8.5, better support for Postgres 17, fix `x-forwarded-host` header usage
* `BASE_URI` is no longer added per default. Lakekeeper now uses the HOST header as well as `x-forwarded-xxx` headers


## [0.5.4] - 2025-05-05

### Fixed
* Missing Volume mount in the database migration job pod

### Changed

## [0.5.3] - 2025-05-03

### Fixed
* Corrected Helm templates to use `.Values.catalog.extraEnvFrom` instead of the incorrect `.Values.catalog.envFrom` to match the `values.yaml`

### Changed
* Update Lakekeeper to Version 0.8.4
* Update OpenFGA dependency to Chart Version 0.2.29, OpenFGA v1.8.11
* Update Postgres dependency to Chart Version 16.6.6

## [0.5.2] - 2025-04-18

### Changed
* Update Lakekeeper to Version 0.8.3 (fixes UI issue where setting permissions doesn't work)

## [0.5.1] - 2025-04-17

### Changed
* Update Lakekeeper to Version 0.8.2
* Add `auth.k8s.legacyEnabled` configuration value

### Fixed
* Changes to db-migration.yaml Job spec:
  * Reference `.Values.catalog.dbMigrations.resources` instead of `.Values.catalog.resources`
  * Reference `.Values.catalog.dbMigrations.podAnnotations` instead of `.Values.catalog.podAnnotations`
* Use `LAKEKEEPER` prefix for openid configuration options

## [0.5.0] - 2025-04-08

### Changed
* Change default of `openfga.datastore.migrationType` to `initContainer` so openfga migrations are run in an init container when `internalOpenFGA` is `true`. [Relevant openfga PR/Issue](https://github.com/openfga/helm-charts/pull/157). Thanks @eklesel!
* Update Lakekeeper to Version 0.8.0
* Update OpenFGA to Chart 0.2.26, Version v1.8.9
* Upgrade PostgreSQL Chart to 16.6.2

## [0.4.3] - 2025-03-04

### Migrating from 0.3.0: 
Please check notes for 0.4.1

### Changed
* Update Lakekeeper to Version `0.7.4`

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
