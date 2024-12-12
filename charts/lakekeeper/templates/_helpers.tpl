{{/*
Expand the name of the chart.
*/}}
{{- define "iceberg-catalog.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "iceberg-catalog.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "iceberg-catalog.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "iceberg-catalog.labels" -}}
helm.sh/chart: {{ include "iceberg-catalog.chart" . }}
{{ include "iceberg-catalog.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "iceberg-catalog.selectorLabels" -}}
app.kubernetes.io/name: {{ include "iceberg-catalog.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "iceberg-catalog.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "iceberg-catalog.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Define the image configs for catalog containers
*/}}
{{- define "iceberg-catalog.image" }}
image: {{ .Values.catalog.image.repository }}:{{ .Values.catalog.image.tag }}
imagePullPolicy: {{ .Values.catalog.image.pullPolicy }}
securityContext:
  runAsUser: {{ .Values.catalog.image.uid }}
  runAsGroup: {{ .Values.catalog.image.gid }}
  {{- if .Values.catalog.containerSecurityContext }}
  {{- omit .Values.catalog.containerSecurityContext "runAsUser" "runAsGroup" | toYaml | nindent 2 }}
  {{- end }}
{{- end }}

{{/*
The list of `envFrom` for catalog Pods
*/}}
{{- define "iceberg-catalog.envFrom" }}
- secretRef:
    name: {{ include "iceberg-catalog.fullname" . }}-config-envs
{{- end }}

{{/*
Construct the `postgresql.fullname` of the postgresql sub-chat chart.
Used to discover the Service and Secret name created by the sub-chart.
*/}}
{{- define "iceberg-catalog.postgresql.fullname" -}}
{{- if .Values.postgresql.fullnameOverride -}}
{{- .Values.postgresql.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default "postgresql" .Values.postgresql.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Construct the `openfga.fullname` of the openfga sub-chat chart.
Used to discover the Service and Secret name created by the sub-chart.
*/}}
{{- define "iceberg-catalog.openfga.fullname" -}}
{{- if .Values.openfga.fullnameOverride }}
{{- .Values.openfga.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default "openfga" .Values.openfga.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
The list of `env` catalog Pods
*/}}
{{- define "iceberg-catalog.env" }}
{{- /* set ICEBERG_REST__PG_USER */ -}}
{{- if .Values.postgresql.enabled }}
- name: ICEBERG_REST__PG_DATABASE_URL_WRITE
  valueFrom:
    secretKeyRef:
      name: {{ include "iceberg-catalog.postgresql.fullname" . }}-svcbind-custom-user
      key: "uri"
{{- end }}

{{- /* set ICEBERG_REST__PG_PASSWORD */ -}}
{{- if .Values.postgresql.enabled }}
{{- if .Values.postgresql.auth.existingSecret }}
- name: ICEBERG_REST__PG_PASSWORD
  valueFrom:
    secretKeyRef:
      name: {{ .Values.postgresql.auth.existingSecret }}
      key: {{ .Values.postgresql.auth.secretKeys.userPasswordKey }}
{{- else }}
- name: ICEBERG_REST__PG_PASSWORD
  valueFrom:
    secretKeyRef:
      name: {{ include "iceberg-catalog.postgresql.fullname" . }}
      key: {{ .Values.postgresql.auth.secretKeys.userPasswordKey }}
{{- end }}
{{- else }}
{{- if .Values.externalDatabase.passwordSecret }}
- name: ICEBERG_REST__PG_PASSWORD
  valueFrom:
    secretKeyRef:
      name: {{ .Values.externalDatabase.passwordSecret }}
      key: {{ .Values.externalDatabase.passwordSecretKey }}
{{- else }}
{{- /* in this case, ICEBERG_REST__PG_PASSWORD is set in the `-config-envs` Secret */ -}}
{{- end }}
{{- end }}

{{- /* set ICEBERG_REST__PG_ENCRYPTION_KEY */ -}}
{{- if eq "postgres" (lower .Values.secretBackend.type) }}
{{- if .Values.secretBackend.postgres.encryptionKeySecret }}
- name: ICEBERG_REST__PG_ENCRYPTION_KEY
  valueFrom:
    secretKeyRef:
      name: {{ .Values.secretBackend.postgres.encryptionKeySecret }}
      key: {{ .Values.secretBackend.postgres.encryptionKeySecretKey }}
{{- else }}
- name: ICEBERG_REST__PG_ENCRYPTION_KEY
  valueFrom:
    secretKeyRef:
      name: {{ include "iceberg-catalog.fullname" . }}-postgres-encryption
      key: encryptionKey
{{- end }}
{{- end }}

{{- if eq "kv2" (lower .Values.secretBackend.type) }}
{{- /* set ICEBERG_REST__KV2__USER */ -}}
{{- if empty .Values.secretBackend.kv2.user }}
{{- if .Values.secretBackend.kv2.userSecret }}
- name: ICEBERG_REST__KV2__USER
  valueFrom:
    secretKeyRef:
      name: {{ .Values.secretBackend.kv2.userSecret }}
      key: {{ .Values.secretBackend.kv2.userSecretKey }}
{{- end }}
{{- end }}

{{- if empty .Values.secretBackend.kv2.password }}
{{- if .Values.secretBackend.kv2.passwordSecret }}
- name: ICEBERG_REST__KV2__PASSWORD
  valueFrom:
    secretKeyRef:
      name: {{ .Values.secretBackend.kv2.passwordSecret }}
      key: {{ .Values.secretBackend.kv2.passwordSecretKey }}
{{- end }}
{{- end }}
{{- end }}

{{- /* user-defined environment variables */ -}}
{{- if .Values.catalog.extraEnv }}
{{ toYaml .Values.catalog.extraEnv }}
{{- end }}

- name: ICEBERG_REST__PLACEHOLDER
  value: "placeholder"
{{- end }}
