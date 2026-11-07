{{/*
Name of the ScaledJob of a size class. Context: dict with "root" and "className".
KEDA names each Job `<ScaledJob name>-<5 random characters>`, so the ScaledJob name keeps 6 characters free
of the 63 a Job name may have.
*/}}
{{- define "lakekeeper.optimize.scaledJobName" -}}
{{- printf "%s-optimize-%s" (include "iceberg-catalog.fullname" .root) .className -}}
{{- end }}

{{/*
Name of the ClusterIP Service KEDA asks for the demand of each size class.
*/}}
{{- define "lakekeeper.optimize.metricsServiceName" -}}
{{- printf "%s-metrics" (include "iceberg-catalog.fullname" .) | trunc 63 | trimSuffix "-" -}}
{{- end }}

{{/*
A quantity in bytes: a whole number with an optional Kubernetes suffix, such as `8Gi` or `500M`.
Empty when the quantity does not parse.
*/}}
{{- define "lakekeeper.optimize.quantityBytes" -}}
{{- if or (kindIs "float64" .) (kindIs "int64" .) (kindIs "int" .) -}}
{{- int64 . -}}
{{- else if regexMatch `^[0-9]+(Ki|Mi|Gi|Ti|Pi|Ei|k|M|G|T|P|E)?$` (toString .) -}}
{{- $number := regexFind `^[0-9]+` (toString .) -}}
{{- $factors := dict "" 1 "Ki" 1024 "Mi" 1048576 "Gi" 1073741824 "Ti" 1099511627776 "Pi" 1125899906842624 "Ei" 1152921504606846976 "k" 1000 "M" 1000000 "G" 1000000000 "T" 1000000000000 "P" 1000000000000000 "E" 1000000000000000000 -}}
{{- mul (int64 $number) (index $factors (trimPrefix $number (toString .))) -}}
{{- end -}}
{{- end }}

{{/*
A Kubernetes quantity as text: a number stays a number, without an exponent.
*/}}
{{- define "lakekeeper.optimize.quantityText" -}}
{{- if or (kindIs "float64" .) (kindIs "int64" .) (kindIs "int" .) -}}
{{- int64 . -}}
{{- else -}}
{{- toString . -}}
{{- end -}}
{{- end }}

{{/*
A number of bytes in the form Kubernetes writes a quantity back: the largest suffix that divides it, binary (`Gi`)
when "binary" is true, else decimal (`G`). KEDA writes the ScaledJob back in this form, and a different text makes
the next `helm upgrade` (server-side apply) fail with a conflict. Context: dict with "bytes" and "binary".
*/}}
{{- define "lakekeeper.optimize.canonicalQuantity" -}}
{{- $base := .binary | ternary 1024 1000 -}}
{{- $suffixes := .binary | ternary (list "" "Ki" "Mi" "Gi" "Ti" "Pi" "Ei") (list "" "k" "M" "G" "T" "P" "E") -}}
{{- $number := int64 .bytes -}}
{{- $exponent := 0 -}}
{{- range until 6 -}}
{{- if and (eq $exponent .) (eq (mod $number $base) 0) -}}
{{- $number = div $number $base -}}
{{- $exponent = add1 $exponent -}}
{{- end -}}
{{- end -}}
{{- printf "%d%s" $number (index $suffixes $exponent) -}}
{{- end }}

{{/*
The whole CPUs of a size class, from `resources.cpu` such as `2`, "2" or `2000m`.
*/}}
{{- define "lakekeeper.optimize.cpus" -}}
{{- int64 (float64 (trimSuffix "000m" (toString .resources.cpu))) -}}
{{- end }}

{{/*
The spill disk of a size class: `optimizeWorkers.spill` with the class `spill` merged over it, the class wins.
Context: dict with "root" and "class". JSON with "type", "storageClassName", "size" (a quantity) and "bytes".
*/}}
{{- define "lakekeeper.optimize.spill" -}}
{{- $spill := deepCopy (.root.Values.optimizeWorkers.spill | default dict) }}
{{- range $key, $value := (.class.spill | default dict) }}
{{- if and (kindIs "map" $value) (kindIs "map" (get $spill $key)) }}
{{- range $innerKey, $innerValue := $value }}
{{- $_ := set (get $spill $key) $innerKey $innerValue }}
{{- end }}
{{- else }}
{{- $_ := set $spill $key $value }}
{{- end }}
{{- end }}
{{- $quantity := $spill.sizePerCpu }}
{{- $bytes := mul (include "lakekeeper.optimize.quantityBytes" $spill.sizePerCpu) (include "lakekeeper.optimize.cpus" .class) }}
{{- if $spill.size }}
{{- $quantity = $spill.size }}
{{- $bytes = include "lakekeeper.optimize.quantityBytes" $spill.size }}
{{- end }}
{{- $size := include "lakekeeper.optimize.canonicalQuantity" (dict "bytes" $bytes "binary" (regexMatch "i$" (toString $quantity))) }}
{{- toJson (dict "type" $spill.type "storageClassName" (($spill.pvc | default dict).storageClassName | default "") "size" $size "bytes" (int64 $bytes)) -}}
{{- end }}

{{/*
A duration of LAKEKEEPER__TASK_* in whole seconds, milliseconds rounded up. Context: dict with "key", the name
under optimizeWorkers, "value", and "positive" when Lakekeeper refuses 0. Fails the render when the duration does not
parse: Lakekeeper reads a value without a unit as a number and refuses it.
*/}}
{{- define "lakekeeper.optimize.seconds" -}}
{{- if not (regexMatch "^[0-9]+(s|ms)$" .value) }}
{{- fail (printf "optimizeWorkers.%s is %q; it must be a whole number of seconds or milliseconds with its unit, such as 300s or 500ms." .key .value) }}
{{- end }}
{{- if and .positive (regexMatch "^0+(s|ms)$" .value) }}
{{- fail (printf "optimizeWorkers.%s is %q; it must be greater than 0." .key .value) }}
{{- end }}
{{- hasSuffix "ms" .value | ternary (div (add (int64 (trimSuffix "ms" .value)) 999) 1000) (int64 (trimSuffix "s" .value)) -}}
{{- end }}

{{/*
The smallest `activeDeadlineSeconds` of a worker Job. After maxLifetime a worker waits for its run, which stops at the
run limit of 3600 seconds; 600 seconds more cover the start of the Pod.
*/}}
{{- define "lakekeeper.optimize.minActiveDeadlineSeconds" -}}
{{- add (int64 (include "lakekeeper.optimize.seconds" (dict "key" "keda.maxLifetime" "value" (toString .Values.optimizeWorkers.keda.maxLifetime) "positive" true))) 3600 600 -}}
{{- end }}

{{/*
`activeDeadlineSeconds` of a worker Job: the value of optimizeWorkers.keda, or the smallest one when it is empty.
*/}}
{{- define "lakekeeper.optimize.activeDeadlineSeconds" -}}
{{- int64 (.Values.optimizeWorkers.keda.activeDeadlineSeconds | default (include "lakekeeper.optimize.minActiveDeadlineSeconds" .)) -}}
{{- end }}

{{/*
The `env` names the chart sets for optimize workers, separated by spaces.
*/}}
{{- define "lakekeeper.optimize.reservedEnv" -}}
LAKEKEEPER__SERVE_HTTP_API LAKEKEEPER__TASK_OPTIMIZE_WORKERS LAKEKEEPER__TASK_EXPIRE_SNAPSHOTS_WORKERS LAKEKEEPER__TASK_REMOVE_ORPHAN_FILES_WORKERS LAKEKEEPER__TASK_SOFT_DELETION_WORKERS LAKEKEEPER__TASK_TABULAR_PURGE_WORKERS LAKEKEEPER__TASK_LOG_CLEANUP_WORKERS LAKEKEEPER__TASK_IDLE_EXIT_AFTER LAKEKEEPER__TASK_MAX_LIFETIME LAKEKEEPER__TASK_DRAIN_TIMEOUT LAKEKEEPER__PG_READ_POOL_CONNECTIONS LAKEKEEPER__PG_WRITE_POOL_CONNECTIONS LAKEKEEPER__OPTIMIZE__AVAILABLE LAKEKEEPER__OPTIMIZE__SIZE_CLASSES LAKEKEEPER__OPTIMIZE__SIZE_CLASS LAKEKEEPER__OPTIMIZE__SPILL_DISK_LIMIT_BYTES TMPDIR
{{- end }}

{{/*
Checks the optimizeWorkers values; fails the render with a message that names the setting.
*/}}
{{- define "lakekeeper.optimize.validate" -}}
{{- if .Values.optimizeWorkers.enabled }}
{{- if ne .Values.lakekeeper.edition "plus" }}
{{- fail "optimizeWorkers.enabled requires lakekeeper.edition \"plus\": optimize workers are part of Lakekeeper Plus." }}
{{- end }}
{{- if empty .Values.optimizeWorkers.sizeClasses }}
{{- fail "optimizeWorkers.enabled requires at least one entry in optimizeWorkers.sizeClasses." }}
{{- end }}
{{- $seen := list }}
{{- $classOfCpus := dict }}
{{- $lowest := dict }}
{{- $highest := dict }}
{{- range $class := .Values.optimizeWorkers.sizeClasses }}
{{- $name := toString $class.name }}
{{- /* Lakekeeper reads a worker's class name from its environment, where 16 is a number and true a boolean. */ -}}
{{- if or (not (regexMatch "^[a-z]([a-z0-9-]*[a-z0-9])?$" $name)) (has $name (list "true" "false")) }}
{{- fail (printf "optimizeWorkers.sizeClasses: the class name %q must start with a lower case letter, contain only lower case letters, digits and hyphens, not end with a hyphen, and not be true or false." $name) }}
{{- end }}
{{- $jobName := include "lakekeeper.optimize.scaledJobName" (dict "root" $ "className" $name) }}
{{- if gt (len $jobName) 57 }}
{{- fail (printf "optimizeWorkers.sizeClasses %s: the ScaledJob name %q has %d characters; at most 57 are allowed, because KEDA adds 6 characters to name each Job. Use a shorter class name, fullnameOverride or release name." $name $jobName (len $jobName)) }}
{{- end }}
{{- if has $name $seen }}
{{- fail (printf "optimizeWorkers.sizeClasses: the class name %q appears more than once." $name) }}
{{- end }}
{{- $seen = append $seen $name }}
{{- if not (and $class.resources $class.resources.cpu $class.resources.memory) }}
{{- fail (printf "optimizeWorkers.sizeClasses %s needs resources.cpu and resources.memory." $name) }}
{{- end }}
{{- /* The CPU limit sets the threads of a worker, which uses whole cores: a limit of 1.5 CPUs gives 1 thread. */ -}}
{{- if not (regexMatch `^[1-9][0-9]*(\.0+|000m)?$` (toString $class.resources.cpu)) }}
{{- fail (printf "optimizeWorkers.sizeClasses %s: resources.cpu is %q; it must be a whole number of CPUs, such as 1, 2 or 4. The chart sets it as the CPU limit of the worker, and a worker uses only whole CPUs." $name (toString $class.resources.cpu)) }}
{{- end }}
{{- $cpus := float64 (include "lakekeeper.optimize.cpus" $class) }}
{{- $cpusKey := toString (int64 $cpus) }}
{{- if hasKey $classOfCpus $cpusKey }}
{{- fail (printf "optimizeWorkers.sizeClasses: %s and %s both have %s CPUs. Every class must have a different number of CPUs: a class takes the tasks larger than the next smaller class, up to its own CPUs." (get $classOfCpus $cpusKey) $name $cpusKey) }}
{{- end }}
{{- $_ := set $classOfCpus $cpusKey $name }}
{{- $classSpill := $class.spill | default dict }}
{{- range $key, $value := $classSpill }}
{{- if not (has $key (list "type" "size" "pvc")) }}
{{- fail (printf "optimizeWorkers.sizeClasses %s: spill.%s is not a known key; the keys are type, size and pvc." $name $key) }}
{{- end }}
{{- end }}
{{- range $key, $value := ($classSpill.pvc | default dict) }}
{{- if ne $key "storageClassName" }}
{{- fail (printf "optimizeWorkers.sizeClasses %s: spill.pvc.%s is not a known key; the only key is storageClassName." $name $key) }}
{{- end }}
{{- end }}
{{- if and (hasKey $classSpill "type") (not (has (toString $classSpill.type) (list "local" "pvc"))) }}
{{- fail (printf "optimizeWorkers.sizeClasses %s: spill.type is %q; it must be local or pvc." $name (toString $classSpill.type)) }}
{{- end }}
{{- if and $classSpill.size (lt (int64 (include "lakekeeper.optimize.quantityBytes" $classSpill.size | default 0)) 1073741824) }}
{{- fail (printf "optimizeWorkers.sizeClasses %s: spill.size is %q; it must be a whole number with an optional suffix and at least 1Gi, such as 20Gi." $name (include "lakekeeper.optimize.quantityText" $classSpill.size)) }}
{{- end }}
{{- $bytes := include "lakekeeper.optimize.quantityBytes" $class.resources.memory }}
{{- if not $bytes }}
{{- fail (printf "optimizeWorkers.sizeClasses %s: resources.memory is %q; it must be a whole number with an optional suffix, such as 8Gi." $name (toString $class.resources.memory)) }}
{{- end }}
{{- $ratio := dict "name" $name "memory" (toString $class.resources.memory) "cpu" (toString $class.resources.cpu) "value" (divf (float64 $bytes) $cpus) }}
{{- if or (empty $lowest) (lt $ratio.value $lowest.value) }}
{{- $lowest = $ratio }}
{{- end }}
{{- if or (empty $highest) (gt $ratio.value $highest.value) }}
{{- $highest = $ratio }}
{{- end }}
{{- $maxJobs := ($class.keda | default dict).maxJobs }}
{{- if not (and (regexMatch "^[0-9]+$" (toString $maxJobs)) (ge (int $maxJobs) 1)) }}
{{- fail (printf "optimizeWorkers.sizeClasses %s: keda.maxJobs must be a whole number of at least 1." $name) }}
{{- end }}
{{- end }}
{{- /* Lakekeeper refuses to start when the memory per CPU of two classes differs by more than 1 %. */ -}}
{{- if gt (divf (subf $highest.value $lowest.value) $lowest.value) 0.01 }}
{{- fail (printf "optimizeWorkers.sizeClasses: %s has %.2f GiB memory per CPU (memory %s, cpu %s) and %s has %.2f GiB (memory %s, cpu %s). Every class must have the same memory per CPU; Lakekeeper refuses classes that differ by more than 1 %%." $highest.name (divf $highest.value 1073741824) $highest.memory $highest.cpu $lowest.name (divf $lowest.value 1073741824) $lowest.memory $lowest.cpu) }}
{{- end }}
{{- $spill := .Values.optimizeWorkers.spill | default dict }}
{{- /* The chart has no values schema: without these checks, a misspelled key would be ignored. */ -}}
{{- range $key, $value := $spill }}
{{- if not (has $key (list "type" "sizePerCpu" "pvc")) }}
{{- fail (printf "optimizeWorkers.spill.%s is not a known key; the keys are type, sizePerCpu and pvc." $key) }}
{{- end }}
{{- end }}
{{- range $key, $value := ($spill.pvc | default dict) }}
{{- if ne $key "storageClassName" }}
{{- fail (printf "optimizeWorkers.spill.pvc.%s is not a known key; the only key is storageClassName." $key) }}
{{- end }}
{{- end }}
{{- if not (has (toString $spill.type) (list "local" "pvc")) }}
{{- fail (printf "optimizeWorkers.spill.type is %q; it must be local or pvc." (toString $spill.type)) }}
{{- end }}
{{- if lt (int64 (include "lakekeeper.optimize.quantityBytes" $spill.sizePerCpu | default 0)) 1073741824 }}
{{- fail (printf "optimizeWorkers.spill.sizePerCpu is %q; it must be a whole number with an optional suffix and at least 1Gi, such as 4Gi." (include "lakekeeper.optimize.quantityText" $spill.sizePerCpu)) }}
{{- end }}
{{- $drain := toString .Values.optimizeWorkers.drainTimeout }}
{{- $drainSeconds := int64 (include "lakekeeper.optimize.seconds" (dict "key" "drainTimeout" "value" $drain)) }}
{{- if lt (int64 .Values.optimizeWorkers.terminationGracePeriodSeconds) (add $drainSeconds 30) }}
{{- fail (printf "optimizeWorkers.terminationGracePeriodSeconds is %v; with drainTimeout %s it must be at least %d, or Kubernetes kills the worker before it stops cleanly. Raise it or lower drainTimeout." .Values.optimizeWorkers.terminationGracePeriodSeconds $drain (add $drainSeconds 30)) }}
{{- end }}
{{- $_ := include "lakekeeper.optimize.seconds" (dict "key" "keda.idleExitAfter" "value" (toString .Values.optimizeWorkers.keda.idleExitAfter) "positive" true) }}
{{- $minDeadline := int64 (include "lakekeeper.optimize.minActiveDeadlineSeconds" .) }}
{{- if lt (int64 (include "lakekeeper.optimize.activeDeadlineSeconds" .)) $minDeadline }}
{{- fail (printf "optimizeWorkers.keda.activeDeadlineSeconds is %v; with keda.maxLifetime %s it must be at least %d: maxLifetime, the run limit of 3600 seconds and 600 seconds to start. A smaller value can stop a Job in the middle of a run. Leave it empty to use this minimum." .Values.optimizeWorkers.keda.activeDeadlineSeconds (toString .Values.optimizeWorkers.keda.maxLifetime) $minDeadline) }}
{{- end }}
{{- $reserved := include "lakekeeper.optimize.reservedEnv" . | splitList " " }}
{{- range .Values.optimizeWorkers.extraEnv }}
{{- if has .name $reserved }}
{{- fail (printf "optimizeWorkers.extraEnv: the chart sets %s for optimize workers; remove it." .name) }}
{{- end }}
{{- end }}
{{- range $class := .Values.optimizeWorkers.sizeClasses }}
{{- range $class.extraEnv }}
{{- if has .name $reserved }}
{{- fail (printf "optimizeWorkers.sizeClasses %s extraEnv: the chart sets %s for optimize workers; remove it." (toString $class.name) .name) }}
{{- end }}
{{- end }}
{{- end }}
{{- /* Optimize workers on the catalog would take the tasks of every class next to the API. */ -}}
{{- $catalogWorkers := index .Values.catalog.config "LAKEKEEPER__TASK_OPTIMIZE_WORKERS" | default 0 }}
{{- range .Values.catalog.extraEnv }}
{{- if eq .name "LAKEKEEPER__TASK_OPTIMIZE_WORKERS" }}
{{- $catalogWorkers = .value | default 0 }}
{{- end }}
{{- end }}
{{- if ne (toString $catalogWorkers) "0" }}
{{- fail "optimizeWorkers.enabled runs optimize tasks in the KEDA Jobs: set LAKEKEEPER__TASK_OPTIMIZE_WORKERS of the catalog (catalog.config or catalog.extraEnv) to 0 or remove it." }}
{{- end }}
{{- /* The chart's entry overrides catalog.config, which reaches the Pods through envFrom. */ -}}
{{- $available := "LAKEKEEPER__OPTIMIZE__AVAILABLE" }}
{{- if and (hasKey .Values.catalog.config $available) (ne (lower (toString (index .Values.catalog.config $available))) "true") }}
{{- fail (printf "optimizeWorkers.enabled sets %s to true on the catalog and the workers: remove %s=%v from catalog.config, or set optimizeWorkers.enabled to false." $available $available (index .Values.catalog.config $available)) }}
{{- end }}
{{- /* In catalog.extraEnv a name of sharedEnv would be a second entry of the name in the catalog's `env`. */ -}}
{{- range .Values.catalog.extraEnv }}
{{- if has .name (list $available "LAKEKEEPER__OPTIMIZE__SIZE_CLASSES") }}
{{- fail (printf "optimizeWorkers.enabled sets %s on the catalog and the workers: remove %s from catalog.extraEnv, or set optimizeWorkers.enabled to false." .name .name) }}
{{- end }}
{{- end }}
{{- end }}
{{- end }}

{{/*
The size classes as the JSON of `LAKEKEEPER__OPTIMIZE__SIZE_CLASSES`. Catalog and workers get the same text.
*/}}
{{- define "lakekeeper.optimize.sizeClassesJson" -}}
{{- $classes := dict }}
{{- range $class := .Values.optimizeWorkers.sizeClasses }}
{{- $_ := set $classes (toString $class.name) (dict "cpu" (include "lakekeeper.optimize.quantityText" $class.resources.cpu) "memory" (include "lakekeeper.optimize.quantityText" $class.resources.memory)) }}
{{- end }}
{{- toJson $classes -}}
{{- end }}

{{/*
`env` entries of the catalog Pods and of every worker Job: optimize is available, and the size classes.
*/}}
{{- define "lakekeeper.optimize.sharedEnv" }}
- name: LAKEKEEPER__OPTIMIZE__AVAILABLE
  value: "true"
- name: LAKEKEEPER__OPTIMIZE__SIZE_CLASSES
  value: {{ include "lakekeeper.optimize.sizeClassesJson" . | quote }}
{{- end }}

{{/*
`env` of a worker Job, each name once: the ScaledJob refuses a name listed twice. A name set more than once keeps
the place of its first entry and the value of its last. Context: dict with "Values", "Release", "Chart", "className",
"classExtraEnv" and "spillBytes" (also used by the check-db init container through its "envTemplate").
*/}}
{{- define "lakekeeper.optimize.env" }}
{{- $order := list }}
{{- $byName := dict }}
{{- range include "lakekeeper.optimize.envEntries" . | fromYamlArray }}
{{- if not (hasKey $byName .name) }}
{{- $order = append $order .name }}
{{- end }}
{{- $_ := set $byName .name . }}
{{- end }}
{{- $env := list }}
{{- range $order }}
{{- $env = append $env (get $byName .) }}
{{- end }}
{{ toYaml $env }}
{{- end }}

{{/*
The `env` entries of a worker Job in order of precedence, the last entry of a name wins: the chart's entries,
`catalog.extraEnv` without the names the chart sets only for workers, `optimizeWorkers.extraEnv`, the class `extraEnv`.
*/}}
{{- define "lakekeeper.optimize.envEntries" }}
{{- include "iceberg-catalog.env.base" . }}
- name: LAKEKEEPER__SERVE_HTTP_API
  value: "false"
- name: LAKEKEEPER__TASK_OPTIMIZE_WORKERS
  value: "1"
- name: LAKEKEEPER__TASK_EXPIRE_SNAPSHOTS_WORKERS
  value: "0"
- name: LAKEKEEPER__TASK_REMOVE_ORPHAN_FILES_WORKERS
  value: "0"
- name: LAKEKEEPER__TASK_SOFT_DELETION_WORKERS
  value: "0"
- name: LAKEKEEPER__TASK_TABULAR_PURGE_WORKERS
  value: "0"
- name: LAKEKEEPER__TASK_LOG_CLEANUP_WORKERS
  value: "0"
- name: LAKEKEEPER__TASK_IDLE_EXIT_AFTER
  value: {{ .Values.optimizeWorkers.keda.idleExitAfter | quote }}
- name: LAKEKEEPER__TASK_MAX_LIFETIME
  value: {{ .Values.optimizeWorkers.keda.maxLifetime | quote }}
- name: LAKEKEEPER__TASK_DRAIN_TIMEOUT
  value: {{ .Values.optimizeWorkers.drainTimeout | quote }}
- name: LAKEKEEPER__PG_READ_POOL_CONNECTIONS
  value: {{ .Values.optimizeWorkers.databasePoolConnections | toString | quote }}
- name: LAKEKEEPER__PG_WRITE_POOL_CONNECTIONS
  value: {{ .Values.optimizeWorkers.databasePoolConnections | toString | quote }}
{{- include "lakekeeper.optimize.sharedEnv" . }}
- name: LAKEKEEPER__OPTIMIZE__SIZE_CLASS
  value: {{ .className | quote }}
{{- /* At the size of the volume the kubelet evicts the Pod (`local`) or writes fail (`pvc`): stay 10 % below it. */}}
- name: LAKEKEEPER__OPTIMIZE__SPILL_DISK_LIMIT_BYTES
  value: {{ div (mul (int64 .spillBytes) 9) 10 | toString | quote }}
- name: TMPDIR
  value: /tmp
{{- $reserved := include "lakekeeper.optimize.reservedEnv" . | splitList " " }}
{{- $inherited := list }}
{{- range .Values.catalog.extraEnv }}
{{- if not (has .name $reserved) }}
{{- $inherited = append $inherited . }}
{{- end }}
{{- end }}
{{- if $inherited }}
{{ tpl (toYaml $inherited) . }}
{{- end }}
{{- if .Values.optimizeWorkers.extraEnv }}
{{ tpl (toYaml .Values.optimizeWorkers.extraEnv) . }}
{{- end }}
{{- if .classExtraEnv }}
{{ tpl (toYaml .classExtraEnv) . }}
{{- end }}
{{- end }}
