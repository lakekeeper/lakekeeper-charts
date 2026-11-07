#!/usr/bin/env bash
# Render tests for templates that `ct install` cannot cover (KEDA is not installed in CI).
#
#   cases/<name>.yaml       must render; the optimize-worker output must equal golden/<name>.yaml
#   cases/fail-<name>.yaml  must fail; the error must contain the text after "# expect: " on its first line
#   With the workers off (the default), the output must have no ScaledJob and no OPTIMIZE__ variable.
#
# UPDATE=1 rewrites the golden files. Needs `helm dependency build charts/lakekeeper` first.
set -euo pipefail
cd "$(dirname "$0")"
CHART=../../charts/lakekeeper
SHOW=(--show-only templates/optimize/optimize-scaledjob.yaml
      --show-only templates/optimize/optimize-metrics-service.yaml
      --show-only templates/catalog/catalog-deployment.yaml)
# Checksums, the chart and app version labels and image tags change with every release, not with the templates.
normalize() {
  sed -E -e 's/^( +checksum\/[a-z-]+: ).*/\1<checksum>/' \
    -e 's/^( +helm\.sh\/chart: ).*/\1<chart>/' \
    -e 's/^( +app\.kubernetes\.io\/version: ).*/\1<app-version>/' \
    -e 's/^( +image: [^:]+:).*/\1<tag>/'
}
failed=0
for f in cases/*.yaml; do
  name=$(basename "$f" .yaml)
  if [[ $name == fail-* ]]; then
    expect=$(head -1 "$f" | sed -n 's/^# expect: //p')
    if [[ -z $expect ]]; then
      echo "FAIL $name: the first line must be \"# expect: <part of the error>\""; failed=1
    elif out=$(helm template lk "$CHART" -n lk -f "$f" 2>&1); then
      echo "FAIL $name: rendered, expected an error containing: $expect"; failed=1
    elif [[ $out != *"$expect"* ]]; then
      echo "FAIL $name: error does not contain: $expect"; echo "$out" | tail -3; failed=1
    else
      echo "ok   $name"
    fi
  else
    out=$(helm template lk "$CHART" -n lk -f "$f" "${SHOW[@]}" | normalize)
    if [ "${UPDATE:-0}" = 1 ]; then
      echo "$out" >"golden/$name.yaml"; echo "upd  $name"
    elif ! diff -u "golden/$name.yaml" <(echo "$out"); then
      echo "FAIL $name: output differs from golden/$name.yaml (UPDATE=1 to accept)"; failed=1
    else
      echo "ok   $name"
    fi
  fi
done
out=$(helm template lk "$CHART" -n lk --set lakekeeper.edition=plus --set lakekeeper.useLicenseSecret=false)
if grep -qE '^kind: ScaledJob|OPTIMIZE__' <<<"$out"; then
  echo "FAIL workers-off: the output has a ScaledJob or an OPTIMIZE__ variable"; failed=1
else
  echo "ok   workers-off"
fi
exit $failed
