# Contributing to Iceberg-Catalog

All commits to main should go through a PR. CI checks should pass before merging the PR.
Before merge commits are squashed. PR titles should follow [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/).

# Testing locally

Install [`ct`](https://github.com/helm/chart-testing) according to the docs.

## Lint charts

Run chart linting without version increment checks:

```bash
ct lint --target-branch main --check-version-increment=false
```

## Install and test charts

Create a local Kubernetes cluster for testing:

```bash
kind create cluster -n lakekeeper-chart
```

Install the charts to verify they work correctly:

```bash
ct install --target-branch main
```