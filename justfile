update-readme:
  helm-docs

# Render tests for templates that `ct install` cannot cover (KEDA ScaledJobs). UPDATE=1 rewrites the golden files.
test-render:
  helm repo add groundhog2k https://groundhog2k.github.io/helm-charts/
  helm repo add openfga https://openfga.github.io/helm-charts
  helm dependency build charts/lakekeeper
  test/render/run.sh
