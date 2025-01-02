gcloud container clusters get-credentials devops-labs01 \
    --region=us-east1

kubectl create clusterrolebinding cluster-admin-binding \
  --clusterrole cluster-admin \
  --user $(gcloud config get-value account)

#Install stack prometheus-grafana
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
helm upgrade --install prometheus prometheus-community/kube-prometheus-stack --version 67.5.0 --namespace obs --create-namespace -f ./values/prom-values.yaml --wait

#Install grafana lokki

helm repo add grafana https://grafana.github.io/helm-charts

helm install loki  grafana/loki-stack -f ./values/loki.yaml --version 2.10.2 -n obs

#Instalação do tempo
helm repo add opentelemetry-helm https://open-telemetry.github.io/opentelemetry-helm-charts

helm upgrade --install my-opentelemetry-collector open-telemetry/opentelemetry-collector --set mode=deployment \
--set image.repository="otel/opentelemetry-collector-k8s" --set command.name="otelcol-k8s" -f ./values/open-collector.yaml --version 0.111.0 -n obs