# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

- BREAKING: Secure default Postgres secret encryption. To upgrade, create a secret with your previous encryption key (default was `<This is unsafe, please set a proper key>`) and set `secretBackend.postgres.encryptionKeySecret` and `secretBackend.postgres.encryptionKeySecretKey` to point to your secret accordingly.


## [0.1.0] - 2024-07-26

Initial Release with lots of cool features!
