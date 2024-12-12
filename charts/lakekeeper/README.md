# lakekeeper

![Version: 0.2.0](https://img.shields.io/badge/Version-0.2.0-informational?style=flat-square) ![Type: application](https://img.shields.io/badge/Type-application-informational?style=flat-square) ![AppVersion: 0.5.1](https://img.shields.io/badge/AppVersion-0.5.1-informational?style=flat-square)

Helm Chart for Lakekeeper - a rust native Iceberg Rest Catalog

**Homepage:** <https://github.com/lakekeeper/lakekeeper>

## Maintainers

| Name | Email | Url |
| ---- | ------ | --- |
| Tobias |  | <https://github.com/twuebi> |
| Christian |  | <https://github.com/c-thiel> |

## Requirements

| Repository | Name | Version |
|------------|------|---------|
| https://openfga.github.io/helm-charts | openfga(openfga) | 0.2.18 |
| oci://registry-1.docker.io/bitnamicharts | postgresql | 16.3.0 |

## Values

| Key | Type | Default | Description |
|-----|------|---------|-------------|
| auth.k8s.createClusterRoleBinding | bool | `true` | If true and `auth.k8s.enabled` is true, a ClusterRoleBinding is created that allows lakekeeper to introspect tokens. |
| auth.k8s.enabled | bool | `false` | If true, kubernetes service accounts can authenticate to Lakekeeper. This option is compatible with `auth.oauth2` - multiple IdPs (OIDC and Kubernetes) can be enabled simultaneously. |
| auth.oauth2 | object | `{"additionalIssuers":[],"audience":"","providerUri":"","ui":{"clientID":"","resource":"","scopes":""}}` | Configuration for the authentication of the catalog. If `auth.oauth2.providerUri` is not set and `auth.kubernetes.enabled` is false, authentication is disabled. |
| auth.oauth2.additionalIssuers | list | `[]` | Additional allow OIDC issuers. The issuer defined in the issuer field of the ``.well-known/openid-configuration`` is always trusted. `additionalIssuers` has no effect if `providerUri` is not set. |
| auth.oauth2.audience | string | `""` | The expected Audience of the OIDC App of lakekeeper. The aud (audience) claim of the JWT token must match this value. Typically this is the Client ID. |
| auth.oauth2.providerUri | string | `""` | If set, access to rest endpoints is secured via an external OIDC-capable IdP. The IdP must expose `{provider_url}/.well-known/openid-configuration` and the openid-configuration needs to have the jwks_uri and issuer defined. For keycloak set: https://keycloak.local/realms/test For Entra-ID set: https://login.microsoftonline.com/{your-tenant-id}/v2.0 |
| auth.oauth2.ui.clientID | string | `""` | Client ID used for the Authorization Code Flow of the UI. Required if Authentication is enabled. |
| auth.oauth2.ui.resource | string | `""` | Resource to request |
| auth.oauth2.ui.scopes | string | `""` | Space separated scopes to request |
| authz.backend | string | `"allowall"` | type of the authorization backend. Available values: "openfga", "allowall" Authorization must not change after bootstrapping! If type "openfga" is chose, consider setting `internalOpenFGA` to true to deploy an OpenFGA instance as a subchart. |
| authz.openfga.apiKey | string | `""` | API Key used to authenticate with OpenFGA. This is used for pre-shared key authentication. If `clientId` is set, the `apiKey` is ignored. |
| authz.openfga.clientId | string | `""` | Client ID used to authenticate with OpenFGA. This is used for OIDC authentication. |
| authz.openfga.clientSecret | string | `""` | Client Secret used to authenticate with OpenFGA. This is used for OIDC authentication. |
| authz.openfga.endpoint | string | `""` | OpenFGA Endpoint (gRPC) Set automatically if `internalOpenFGA` is true. |
| authz.openfga.store | string | `""` | Name of the Store to use in OpenFGA Defaults to "lakekeeper" |
| authz.openfga.tokenEndpoint | string | `""` | OIDC token endpoint used to authenticate with OpenFGA. Used when exchanging client credentials for an access token for OpenFGA. Required if Client ID is set. |
| catalog.affinity | object | `{}` | affinity for the catalog Pods |
| catalog.annotations | object | `{}` | Annotations for the catalog Deployment |
| catalog.autoscaling.enabled | bool | `false` | if the HorizontalPodAutoscaler is enabled for the catalog Pods |
| catalog.autoscaling.maxReplicas | int | `2` | maximum number of replicas for the catalog Pods |
| catalog.autoscaling.metrics | list | `[]` | metrics for the HorizontalPodAutoscaler |
| catalog.command | list | `[]` | Overwrite the command of the catalog container. If not set, the default entrypoint of the image is used |
| catalog.config | object | `{}` | Configuration options for the catalog. Please check the documentation for the available options. https://docs.lakekeeper.io/docs/nightly/configuration/ Configuration items are mounted as environment variables. ICEBERG_REST__BASE_URI is required if ingress is disabled - otherwise the catalog will only work inside the cluster. |
| catalog.containerSecurityContext | <html><a href="https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.29/#podsecuritycontext-v1-core">podsecuritycontext-v1-core</a></html> | `{}` |  security context for the catalog container. `runAsUser` is ignored, please set with `catalog.image.uid`, `runAsGroup` is ignored, please set with `catalog.image.gid` |
| catalog.dbMigrations.annotations | object | `{}` | Annotations for the migration job |
| catalog.dbMigrations.enabled | bool | `true` | if the db-migrations Job is created. if `false`, you have to MANUALLY run `airflow db upgrade` when required |
| catalog.dbMigrations.extraInitContainers | <html><a href="https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.29/#container-v1-core">container</a></html> | `[]` |  extra init-containers for the migration Pod |
| catalog.dbMigrations.labels | object | `{}` | Labels for the catalog migration job |
| catalog.dbMigrations.podAnnotations | object | `{}` | Annotations for the migration pod |
| catalog.dbMigrations.podLabels | object | `{}` | Labels for the migration pod |
| catalog.dbMigrations.resources | <html><a href="https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.29/#resourcerequirements-v1-core">resource requirements</a></html> | `{}` |  resources for the catalog container of the catalog pod |
| catalog.extraContainers | list of <html><a href="https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.29/#container-v1-core">containers</a></html> | `[]` |  extra containers for the catalog Pods |
| catalog.extraEnv | list of <html><a href="https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.29/#envvar-v1-core">envvar-v1-core</a></html> | `[]` |  extra variables for the catalog Pods |
| catalog.extraEnvFrom | list of <html><a href="https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.29/#envfromsource-v1-core">envfromsource-v1-core</a></html> | `[]` |  extra variables for the catalog Pods |
| catalog.extraInitContainers | <html><a href="https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.29/#container-v1-core">container</a></html> | `[]` |  extra init-containers for the catalog Pods |
| catalog.extraVolumeMounts | <html><a href="https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.29/#volumemount-v1-core">volume mount</a></html> | `[]` |  extra VolumeMounts for the catalog Pods |
| catalog.extraVolumes | <html><a href="https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.29/#volume-v1-core">volume</a></html> | `[]` |  extra Volumes for the catalog Pods |
| catalog.image.gid | int | `65534` | 65534 = nobody of google container distroless |
| catalog.image.pullPolicy | string | `"IfNotPresent"` | The image pull policy |
| catalog.image.repository | string | `"quay.io/lakekeeper/catalog"` | The image repository to pull from |
| catalog.image.tag | string | `"v0.5.1"` | The image tag to pull |
| catalog.image.uid | int | `65532` | 65532 = nonroot of google container distroless |
| catalog.ingress.annotations | object | `{}` | annotations for the catalog Ingress |
| catalog.ingress.enabled | bool | `false` | if we should deploy Ingress resources |
| catalog.ingress.host | string | `""` | the hostname for the catalog Ingress. For example, `data.example.com`. |
| catalog.ingress.ingressClassName | string | `""` | the Ingress Class for the catalog Ingress |
| catalog.ingress.labels | object | `{}` | additional labels for the catalog Ingress |
| catalog.ingress.path | string | `""` | the path for the catalog Ingress. To host the catalog at the url `https://data.example.com/iceberg-catalog`, set `path: "/iceberg-catalog"`. If a path is set, the ingress must strip the path before forwarding to the service! This helm-chart does not take care of this, as it depends on the type of Ingress Controller used. For example, for NGINX Ingress Controller, set the annotation `nginx.ingress.kubernetes.io/rewrite-target: /` |
| catalog.ingress.tls.enabled | bool | `false` | enable TLS termination for the catalog Ingress |
| catalog.ingress.tls.secretName | string | `""` | the name of a pre-created Secret containing a TLS private key and certificate |
| catalog.initContainers.checkDb.resources | <html><a href="https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.29/#resourcerequirements-v1-core">resource requirements</a></html> | `{}` |  resource requests/limits for the "check-db" init-containers |
| catalog.labels | object | `{}` | Labels for the catalog Deployment |
| catalog.livenessProbe.enabled | bool | `true` | if the liveness probes of the catalog Pods are enabled |
| catalog.livenessProbe.failureThreshold | int | `5` |  |
| catalog.livenessProbe.initialDelaySeconds | int | `1` |  |
| catalog.livenessProbe.periodSeconds | int | `5` |  |
| catalog.livenessProbe.timeoutSeconds | int | `5` |  |
| catalog.nodeSelector | <html><a href="https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/#nodeselector"> | `{}` |  node selector configs for the catalog Pods |
| catalog.podAnnotations | object | `{}` | Pod annotations for the catalog Deployment |
| catalog.podDisruptionBudget.enabled | bool | `false` | if a PodDisruptionBudget resource is created for the catalog |
| catalog.podDisruptionBudget.maxUnavailable | string | `""` | the maximum unavailable pods/percentage for the catalog |
| catalog.podDisruptionBudget.minAvailable | string | `""` | the minimum available pods/percentage for the catalog |
| catalog.podLabels | object | `{}` | Pod labels for the catalog Deployment |
| catalog.podSecurityContext | <html><a href="https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.29/#podsecuritycontext-v1-core">podsecuritycontext-v1-core</a></html> | `{}` |  security context for the catalog Pods. `runAsUser` and `runAsGroup` are ignored for the catalog container, please set with `catalog.image.uid` and `catalog.image.gid` |
| catalog.readinessProbe.enabled | bool | `true` | if the readiness probes of the catalog Pods are enabled |
| catalog.readinessProbe.failureThreshold | int | `5` |  |
| catalog.readinessProbe.initialDelaySeconds | int | `1` |  |
| catalog.readinessProbe.periodSeconds | int | `5` |  |
| catalog.readinessProbe.timeoutSeconds | int | `5` |  |
| catalog.replicas | int | `1` | Number of replicas to deploy. Replicas are stateless. |
| catalog.resources | <html><a href="https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.29/#resourcerequirements-v1-core">resource requirements</a></html> | `{}` |  resources for the catalog container of the catalog pod |
| catalog.safeToEvict | bool | `true` | if we add the annotation: "cluster-autoscaler.kubernetes.io/safe-to-evict" = "true" |
| catalog.service.annotations | object | `{}` | catalog service annotations |
| catalog.service.externalPort | int | `8181` | catalog service external port |
| catalog.service.loadBalancerIP | string | `""` | catalog service ip of the load balancer service. Only used when `type: LoadBalancer` |
| catalog.service.loadBalancerSourceRanges | list | `[]` | Source ip ranges for the catalog services. Only used when `type: LoadBalancer` |
| catalog.service.nodePort | object | `{"http":""}` | catalog service node port Only used when `type: NodePort` |
| catalog.service.sessionAffinity | string | `"None"` | catalog service session affinity |
| catalog.service.sessionAffinityConfig | object | `{}` | catalog service session affinity config |
| catalog.service.type | string | `"ClusterIP"` | catalog service type |
| catalog.terminationPeriod | int | `60` | how many seconds to wait after SIGTERM before SIGKILL of the catalog. Default is 60 seconds. |
| catalog.tolerations | <html><a href="https://kubernetes.io/docs/reference/generated/kubernetes-api/v1.29/#toleration-v1-core">toleration</a></html> | `[]` |  tolerations for the catalog Pods |
| catalog.topologySpreadConstraints | <html><a href="https://kubernetes.io/docs/concepts/scheduling-eviction/topology-spread-constraints/">topologySpreadConstraints</a></html> | `[]` |  topology spread constraints the catalog Pods |
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
| helmWait | bool | `true` | If true, remove the helm.sh/hook for jobs that need to run before the catalog is started. If this is false, helm install --wait will not work. |
| imagePullSecrets | list of <html><a href="https://kubernetes.io/docs/tasks/configure-pod-container/pull-image-private-registry/">image pull secrets</a></html> | `[]` |  pull secrets for private repositories |
| internalOpenFGA | bool | `false` | if an OpenFGA instance is deployed as a subchart. When setting `internalOpenFGA` to true, the `openfga` subchart is deployed. |
| nameOverride | string | `<chart-name>` | Override the name of the chart. |
| openfga.datastore.engine | string | `"postgres"` |  |
| openfga.datastore.migrationType | string | `"job"` |  |
| openfga.datastore.uriSecret | string | `"lakekeeper-openfga-pg-svcbind-postgres"` |  |
| openfga.migrate.annotations."helm.sh/hook" | string | `"post-install, post-upgrade, post-rollback"` |  |
| openfga.postgresql.enabled | bool | `true` |  |
| openfga.postgresql.fullnameOverride | string | `"lakekeeper-openfga-pg"` |  |
| openfga.postgresql.serviceBindings.enabled | bool | `true` |  |
| openfga.replicaCount | int | `1` |  |
| postgresql.auth.database | string | `"catalog"` | the postgres database to create |
| postgresql.auth.existingSecret | string | `""` | the name of a pre-created secret containing the postgres password |
| postgresql.auth.password | string | `""` | the postgres user's password. if not specified, a random password is generated and stored in a secret |
| postgresql.auth.secretKeys.adminPasswordKey | string | `"postgres-password"` | the key within `postgresql.existingSecret` containing the admin (postgres) password string |
| postgresql.auth.secretKeys.userPasswordKey | string | `"password"` | the key within `postgresql.existingSecret` containing the user password string |
| postgresql.auth.username | string | `"catalog"` | the postgres user to create |
| postgresql.enabled | bool | `true` | if the `bitnami/postgresql` chart is used. [WARNING] embedded Postgres is NOT recommended for production. Use an external database instead. set to `false` if using `externalDatabase.*` |
| postgresql.nameOverride | string | `"lakekeeper-pg"` |  |
| postgresql.persistence.accessModes | list | `["ReadWriteOnce"]` | the access modes of the PVC |
| postgresql.persistence.enabled | bool | `true` | if postgres will use Persistent Volume Claims to store data. if false, data will be LOST as postgres Pods restart |
| postgresql.persistence.size | string | `"5Gi"` | the size of PVC to request |
| postgresql.persistence.storageClass | string | `""` | the StorageClass used by the PVC |
| postgresql.serviceBindings.enabled | bool | `true` |  |
| secretBackend.kv2.password | string | `""` | password for authentication consider using a secret for the password |
| secretBackend.kv2.passwordSecret | string | `""` | the name of a pre-created secret containing the KV2 password |
| secretBackend.kv2.passwordSecretKey | string | `"password"` | the key within `kv2.passwordSecret` containing the password string |
| secretBackend.kv2.secretMount | string | `"kv/data/iceberg"` | path to the secret mount in the KV2 secret store. |
| secretBackend.kv2.url | string | `""` | the URL of the KV2 secret store |
| secretBackend.kv2.user | string | `""` | user name for authentication |
| secretBackend.kv2.userSecret | string | `""` | the name of a pre-created secret containing the KV2 user |
| secretBackend.kv2.userSecretKey | string | `"username"` | the key within `kv2.userSecret` containing the user string |
| secretBackend.postgres.encryptionKeySecret | string | `""` | Name of the secret containing the encryption key. If not set, a random key is generated and stored in a secret. We recommend setting this to a pre-existing secret. If you loose the key, you loose access to all secrets. |
| secretBackend.postgres.encryptionKeySecretKey | string | `"encryptionKey"` | Name of the key within `encryptionKeySecret` containing the encryption key string |
| secretBackend.type | string | `"Postgres"` | the type of secret store to use. Available values: "Postgres", "KV2" |
| serviceAccount.annotations | object | `{}` | Annotations to add to the service account |
| serviceAccount.automount | bool | `true` | Option to opt-out of the default behavior of service account token auto-mounting. |
| serviceAccount.create | bool | `true` | Specifies whether a service account should be created. If `false`, you must create the you must create the service account outside this chart with name: `serviceAccount.name` |
| serviceAccount.name | string | `""` | Name of the service account to use. If not set and create is true, a name is generated using the fullname |

----------------------------------------------
Autogenerated from chart metadata using [helm-docs v1.14.2](https://github.com/norwoodj/helm-docs/releases/v1.14.2)
