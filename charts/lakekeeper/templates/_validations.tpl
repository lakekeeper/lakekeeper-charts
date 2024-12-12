{{/* Require that .Values.authz.type is either "allowall" or "openfga" */}}
{{- if not (or (eq .Values.authz.backend "allowall") (eq .Values.authz.backend "openfga")) }}
{{ required "authz.backend must be one of `allowall` or `openfga`. " nil }}
{{- end }}

