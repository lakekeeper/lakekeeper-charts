# Iceberg Catalog Helmchart

![Version: 0.0.0](https://img.shields.io/badge/Version-0.0.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 0.1.0](https://img.shields.io/badge/AppVersion-0.1.0-informational?style=flat-square)

A Helm chart for Kubernetes

**Homepage:** <https://github.com/hansetag/iceberg-catalog>

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| Tobias |  | <https://github.com/twuebi> |
| Christian |  | <https://github.com/c-thiel> |

## Requirements

| Repository | Name | Version |
|------------|------|---------|
| https://charts.helm.sh/stable | postgresql | 8.6.4 |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| catalog.affinity | object | `{}` | affinity for the catalog Pods |
| catalog.annotations | object | `{}` | Annotations for the catalog Deployment |
| catalog.autoscaling | object | `{}` | configs for the HorizontalPodAutoscaler of the catalog Pods. We are using autoscaling/v2 |
| catalog.command | string | `""` |  |
| catalog.config | object | `{}` | Configuration options for the catalog. Please check the documentation for the available options. Configuration items are mounted as environment variables. |
| catalog.containerSecurityContext | [podsecuritycontext-v1-core](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.29/#podsecuritycontext-v1-core | `{}` | ) security context for the catalog container. `runAsUser` is ignored, please set with `catalog.image.uid`, `runAsGroup` is ignored, please set with `catalog.image.gid` |
| catalog.extraContainers | list of [containers](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.29/#container-v1-core | `[]` | ) extra containers for the catalog Pods |
| catalog.extraEnv | list of [envvar-v1-core](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.29/#envvar-v1-core | `[]` | ) extra variables for the catalog Pods |
| catalog.extraEnvFrom | list of [envfromsource-v1-core](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.29/#envfromsource-v1-core | `[]` | ) extra variables for the catalog Pods |
| catalog.extraInitContainers | list | `[]` |  |
| catalog.extraVolumeMounts | list | `[]` |  |
| catalog.extraVolumes | list | `[]` |  |
| catalog.image.gid | int | `65534` | 65534 = nobody of google container distroless |
| catalog.image.pullPolicy | string | `"IfNotPresent"` |  |
| catalog.image.repository | string | `"quay.io/hansetag/iceberg-catalog"` | The image repository to pull from |
| catalog.image.tag | string | `"latest"` | The image tag to pull |
| catalog.image.uid | int | `65532` | 65532 = nonroot of google container distroless |
| catalog.labels | object | `{}` | Labels for the catalog Deployment |
| catalog.livenessProbe.enabled | bool | `true` |  |
| catalog.livenessProbe.failureThreshold | int | `5` |  |
| catalog.livenessProbe.initialDelaySeconds | int | `1` |  |
| catalog.livenessProbe.periodSeconds | int | `5` |  |
| catalog.livenessProbe.timeoutSeconds | int | `5` |  |
| catalog.nodeSelector | [nodeSelector](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#nodeselector | `{}` | ) node selector configs for the catalog Pods |
| catalog.podAnnotations | object | `{}` | Pod annotations for the catalog Deployment |
| catalog.podDisruptionBudget.enabled | bool | `false` | if a PodDisruptionBudget resource is created for the catalog |
| catalog.podDisruptionBudget.maxUnavailable | string | `""` | the maximum unavailable pods/percentage for the catalog |
| catalog.podDisruptionBudget.minAvailable | string | `""` | the minimum available pods/percentage for the catalog |
| catalog.podLabels | object | `{}` | Pod labels for the catalog Deployment |
| catalog.podSecurityContext | [podsecuritycontext-v1-core](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.29/#podsecuritycontext-v1-core | `{}` | ) security context for the catalog Pods. `runAsUser` and `runAsGroup` are ignored for the catalog container, please set with `catalog.image.uid` and `catalog.image.gid` |
| catalog.readinessProbe.enabled | bool | `true` |  |
| catalog.readinessProbe.failureThreshold | int | `5` |  |
| catalog.readinessProbe.initialDelaySeconds | int | `1` |  |
| catalog.readinessProbe.periodSeconds | int | `5` |  |
| catalog.readinessProbe.timeoutSeconds | int | `5` |  |
| catalog.replicas | int | `1` | Number of replicas to deploy. Replicas are stateless. |
| catalog.resources | object | `{}` | [resource requirements](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.29/#resourcerequirements-v1-core) resources for the catalog container of the catalog pod |
| catalog.safeToEvict | bool | `true` | if we add the annotation: "cluster-autoscaler.kubernetes.io/safe-to-evict" = "true" |
| catalog.terminationPeriod | int | `60` | how many seconds to wait after SIGTERM before SIGKILL of the catalog |
| catalog.tolerations | [toleration](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.29/#toleration-v1-core | `[]` | ) tolerations for the catalog Pods |
| catalog.topologySpreadConstraints | [topologySpreadConstraints](https://kubernetes.io/docs/concepts/scheduling-eviction/topology-spread-constraints/ | `[]` | ) topology spread constraints the catalog Pods |
| externalDatabase.database | string | `"catalog"` |  |
| externalDatabase.host | string | `"localhost"` |  |
| externalDatabase.password | string | `""` |  |
| externalDatabase.passwordSecret | string | `""` |  |
| externalDatabase.passwordSecretKey | string | `"postgresql-password"` |  |
| externalDatabase.port | int | `5432` |  |
| externalDatabase.type | string | `"postgres"` |  |
| externalDatabase.user | string | `"catalog"` |  |
| externalDatabase.userSecret | string | `""` |  |
| externalDatabase.userSecretKey | string | `"postgresql-user"` |  |
| fullnameOverride | string | `<release-name>-<chart-name>` | Override the fully qualified chart name. |
| imagePullSecrets | list of [image pull secrets](https://kubernetes.io/docs/tasks/configure-pod-container/pull-image-private-registry/ | `[]` | ) pull secrets for private repositories |
| nameOverride | string | `<chart-name>` | Override the name of the chart. |
| postgresql.enabled | bool | `true` |  |
| postgresql.existingSecret | string | `""` |  |
| postgresql.existingSecretKey | string | `"postgresql-password"` |  |
| postgresql.persistence.accessModes[0] | string | `"ReadWriteOnce"` |  |
| postgresql.persistence.enabled | bool | `true` |  |
| postgresql.persistence.size | string | `"5Gi"` |  |
| postgresql.persistence.storageClass | string | `""` |  |
| postgresql.postgresqlDatabase | string | `"catalog"` |  |
| postgresql.postgresqlPassword | string | `"catalog"` |  |
| postgresql.postgresqlUsername | string | `"postgres"` |  |
| serviceAccount.annotations | object | `{}` |  |
| serviceAccount.automount | bool | `true` |  |
| serviceAccount.create | bool | `true` |  |
| serviceAccount.name | string | `""` |  |
| serviceAccount.service.annotations | object | `{}` |  |
| serviceAccount.service.externalPort | int | `8080` |  |
| serviceAccount.service.loadBalancerIP | string | `""` |  |
| serviceAccount.service.loadBalancerSourceRanges | list | `[]` |  |
| serviceAccount.service.nodePort.http | string | `""` |  |
| serviceAccount.service.sessionAffinity | string | `"None"` |  |
| serviceAccount.service.sessionAffinityConfig | object | `{}` |  |
| serviceAccount.service.type | string | `"ClusterIP"` |  |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.14.2](https://github.com/norwoodj/helm-docs/releases/v1.14.2)
