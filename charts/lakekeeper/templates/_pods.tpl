{{/*
Define an init-container which checks the DB status
EXAMPLE USAGE: {{ include "iceberg-catalog.init_container.check_db" (dict "Release" .Release "Values" .Values "Chart" .Chart "awaitMigration" true) }}
*/}}
{{- define "iceberg-catalog.init_container.check_db" }}
{{/*
Wait for OpenFGA - source: https://github.com/openfga/helm-charts/blob/main/charts/openfga/templates/deployment.yaml
*/}}
{{- if and (has .Values.openfga.datastore.engine (list "postgres" "mysql")) .Values.openfga.datastore.applyMigrations .Values.openfga.datastore.waitForMigrations (eq .Values.openfga.datastore.migrationType "job") }}
- name: wait-for-openfga
  securityContext:
    {{- toYaml .Values.openfga.securityContext | nindent 12 }}
  image: "{{ .Values.openfga.initContainer.repository }}:{{ .Values.openfga.initContainer.tag }}"
  imagePullPolicy: {{ .Values.openfga.initContainer.pullPolicy }}
  args: ["job-wr", '{{ include "iceberg-catalog.openfga.fullname" . }}-migrate']
  resources:
    {{- toYaml .Values.openfga.datastore.migrations.resources | nindent 12 }}
{{- end }}
- name: check-db
  {{- include "iceberg-catalog.image" . | indent 2 }}
  resources:
    {{- toYaml .Values.catalog.initContainers.checkDb.resources | nindent 4 }}
  envFrom:
    {{- include "iceberg-catalog.envFrom" . | indent 4 }}
    {{- if .Values.catalog.envFrom -}}
    {{- toYaml .Values.catalog.envFrom | nindent 4 }}
    {{- end }}
  env:
    {{- include "iceberg-catalog.env" . | indent 4 }}
  {{- if .Values.catalog.command }}
  command:
    {{- toYaml .Values.catalog.command | nindent 4 }}
  {{- end }}
  args:
    - wait-for-db
    {{- if eq .awaitMigration true }}
    - -dm
    {{- else }}
    - -d
    {{- end }}
    - -r
    - "100"
    - -b
    - "2"
  {{- with .Values.catalog.extraVolumeMounts }}
  volumeMounts:
    {{- toYaml . | nindent 4 }}
  {{- end }}
{{- end }}
