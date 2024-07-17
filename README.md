# iceberg-catalog

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
| catalog.autoscaling.enabled | bool | `false` | if the HorizontalPodAutoscaler is enabled for the catalog Pods |
| catalog.autoscaling.maxReplicas | int | `2` | maximum number of replicas for the catalog Pods |
| catalog.autoscaling.metrics | list | `[]` | metrics for the HorizontalPodAutoscaler |
| catalog.command | string | `""` | Overwrite the command of the catalog container. If not set, the default entrypoint of the image is used |
| catalog.config | object | `{}` | Configuration options for the catalog. Please check the documentation for the available options. Configuration items are mounted as environment variables. |
| catalog.containerSecurityContext | [podsecuritycontext-v1-core](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.29/#podsecuritycontext-v1-core | `{}` | ) security context for the catalog container. `runAsUser` is ignored, please set with `catalog.image.uid`, `runAsGroup` is ignored, please set with `catalog.image.gid` |
| catalog.dbMigrations.annotations | object | `{}` | Annotations for the migration job |
| catalog.dbMigrations.enabled | bool | `true` | if the db-migrations Job is created. if `false`, you have to MANUALLY run `airflow db upgrade` when required |
| catalog.dbMigrations.extraInitContainers | [container](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.29/#container-v1-core | `[]` | ) extra init-containers for the migration Pod |
| catalog.dbMigrations.labels | object | `{}` | Labels for the catalog migration job |
| catalog.dbMigrations.podAnnotations | object | `{}` | Annotations for the migration pod |
| catalog.dbMigrations.podLabels | object | `{}` | Labels for the migration pod |
| catalog.dbMigrations.resources | object | `{}` | [resource requirements](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.29/#resourcerequirements-v1-core) resources for the catalog container of the catalog pod |
| catalog.extraContainers | list of [containers](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.29/#container-v1-core | `[]` | ) extra containers for the catalog Pods |
| catalog.extraEnv | list of [envvar-v1-core](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.29/#envvar-v1-core | `[]` | ) extra variables for the catalog Pods |
| catalog.extraEnvFrom | list of [envfromsource-v1-core](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.29/#envfromsource-v1-core | `[]` | ) extra variables for the catalog Pods |
| catalog.extraInitContainers | [container](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.29/#container-v1-core | `[]` | ) extra init-containers for the catalog Pods |
| catalog.extraVolumeMounts | [volume mount](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.29/#volumemount-v1-core | `[]` | ) extra VolumeMounts for the catalog Pods |
| catalog.extraVolumes | [volume](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.29/#volume-v1-core | `[]` | ) extra Volumes for the catalog Pods |
| catalog.image.gid | int | `65534` | 65534 = nobody of google container distroless |
| catalog.image.pullPolicy | string | `"IfNotPresent"` |  |
| catalog.image.repository | string | `"quay.io/hansetag/iceberg-catalog"` | The image repository to pull from |
| catalog.image.tag | string | `"latest"` | The image tag to pull |
| catalog.image.uid | int | `65532` | 65532 = nonroot of google container distroless |
| catalog.ingress.annotations | object | `{}` | annotations for the catalog Ingress |
| catalog.ingress.enabled | bool | `false` | if we should deploy Ingress resources |
| catalog.ingress.host | string | `""` | the hostname for the catalog Ingress. For example, `data.example.com`. |
| catalog.ingress.ingressClassName | string | `""` | the Ingress Class for the catalog Ingress |
| catalog.ingress.labels | object | `{}` | additional labels for the catalog Ingress |
| catalog.ingress.path | string | `""` | the path for the catalog Ingress. To host the catalog at the url `https://data.example.com/catalog`, set `path: "/catalog"` |
| catalog.ingress.tls.enabled | bool | `false` | enable TLS termination for the catalog Ingress |
| catalog.ingress.tls.secretName | string | `""` | the name of a pre-created Secret containing a TLS private key and certificate |
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
| catalog.service.annotations | object | `{}` | catalog service annotations |
| catalog.service.externalPort | int | `8080` | catalog service external port |
| catalog.service.loadBalancerIP | string | `""` | catalog service ip of the load balancer service. Only used when `type: LoadBalancer` |
| catalog.service.loadBalancerSourceRanges | list | `[]` | Source ip ranges for the catalog services. Only used when `type: LoadBalancer` |
| catalog.service.nodePort | object | `{"http":""}` | catalog service node port Only used when `type: NodePort` |
| catalog.service.sessionAffinity | string | `"None"` | catalog service session affinity |
| catalog.service.sessionAffinityConfig | object | `{}` | catalog service session affinity config |
| catalog.service.type | string | `"ClusterIP"` | catalog service type |
| catalog.terminationPeriod | int | `60` | how many seconds to wait after SIGTERM before SIGKILL of the catalog |
| catalog.tolerations | [toleration](https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.29/#toleration-v1-core | `[]` | ) tolerations for the catalog Pods |
| catalog.topologySpreadConstraints | [topologySpreadConstraints](https://kubernetes.io/docs/concepts/scheduling-eviction/topology-spread-constraints/ | `[]` | ) topology spread constraints the catalog Pods |
| clusterDomain | string | `"cluster.local"` | kubernetes cluster domain name. Used for service discovery in the catalog. |
| externalDatabase.database | string | `"catalog"` |  |
| externalDatabase.host_read | string | `"localhost"` | hostname to use for read instances of the external database |
| externalDatabase.host_write | string | `"localhost"` | hostname to use for write instances of the external database. For single read/write instances, this should be the same as `host_read` |
| externalDatabase.password | string | `""` |  |
| externalDatabase.passwordSecret | string | `""` |  |
| externalDatabase.passwordSecretKey | string | `"postgresql-password"` |  |
| externalDatabase.port | int | `5432` |  |
| externalDatabase.type | string | `"postgres"` | the type of external database. allowed values: "postgres" |
| externalDatabase.user | string | `"catalog"` |  |
| externalDatabase.userSecret | string | `""` |  |
| externalDatabase.userSecretKey | string | `"postgresql-user"` |  |
| fullnameOverride | string | `<release-name>-<chart-name>` | Override the fully qualified chart name. |
| imagePullSecrets | list of [image pull secrets](https://kubernetes.io/docs/tasks/configure-pod-container/pull-image-private-registry/ | `[]` | ) pull secrets for private repositories |
| nameOverride | string | `<chart-name>` | Override the name of the chart. |
| postgresql.enabled | bool | `true` | if the `stable/postgresql` chart is used. [WARNING] embedded Postgres is NOT recommended for production. Use an external database instead. set to `false` if using `externalDatabase.*` |
| postgresql.existingSecret | string | `""` | the name of a pre-created secret containing the postgres password |
| postgresql.existingSecretKey | string | `"postgresql-password"` | the key within `postgresql.existingSecret` containing the password string |
| postgresql.persistence.accessModes | list | `["ReadWriteOnce"]` | the access modes of the PVC |
| postgresql.persistence.enabled | bool | `true` | if postgres will use Persistent Volume Claims to store data. if false, data will be LOST as postgres Pods restart |
| postgresql.persistence.size | string | `"5Gi"` | the size of PVC to request |
| postgresql.persistence.storageClass | string | `""` | the StorageClass used by the PVC |
| postgresql.postgresqlDatabase | string | `"catalog"` | the postgres database to use |
| postgresql.postgresqlPassword | string | `"catalog"` | the postgres user's password |
| postgresql.postgresqlUsername | string | `"postgres"` | the postgres user to create |
| serviceAccount.annotations | object | `{}` | Annotations to add to the service account |
| serviceAccount.automount | bool | `true` | Option to opt-out of the default behavior of service account token auto-mounting. |
| serviceAccount.create | bool | `true` | Specifies whether a service account should be created. If `false`, you must create the you must create the service account outside this chart with name: `serviceAccount.name` |
| serviceAccount.name | string | `""` | Name of the service account to use. If not set and create is true, a name is generated using the fullname |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.14.2](https://github.com/norwoodj/helm-docs/releases/v1.14.2)
