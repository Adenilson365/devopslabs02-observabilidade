#Configuração do cluster GKE

gcloud container clusters get-credentials devops-labs01 --region=us-east1

kubectl create clusterrolebinding cluster-admin-binding \
  --clusterrole cluster-admin \
  --user $(gcloud config get-value account)

# Install nginx ingress controller
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.12.0-beta.0/deploy/static/provider/cloud/deploy.yaml

#Install cert-manager
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.16.2/cert-manager.yaml

#Capturar o ip externo público da máquina host, para adicionar no whitelist do ingress de observabilidade
IP_ATUAL=$(cat ./config/ingress-observability.yaml | grep -oE '\b([0-9]{1,3}\.){3}[0-9]{1,3}\b')
MEU_IP=$(wget -qO- https://www.meuip.com.br/ |  grep -oE '\b([0-9]{1,3}\.){3}[0-9]{1,3}\b' | head -n 1)

echo "atual: $IP_ATUAL/32 - Novo: $MEU_IP/32"
sed -i "s|nginx.ingress.kubernetes.io/whitelist-source-range: '$IP_ATUAL/32'|nginx.ingress.kubernetes.io/whitelist-source-range: '$MEU_IP/32'|g" ./config/ingress-observability.yaml


#Instalação da aplicação

kubectl apply -f ./config/namespace.yaml
kubectl apply -f ./config/
kubectl apply -f ./deploys/

#Adicionar e atualizar os charts helm necessários
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add grafana https://grafana.github.io/helm-charts
helm repo add opentelemetry-helm https://open-telemetry.github.io/opentelemetry-helm-charts
helm repo add grafana https://grafana.github.io/helm-charts
helm repo update
#Install stack prometheus-grafana

helm upgrade --install prometheus prometheus-community/kube-prometheus-stack --version 67.5.0 --namespace obs  -f ./values/prom-values.yaml --wait

#Install grafana loki stack

#helm upgrade --install loki  grafana/loki-stack --version 2.10.2 -n obs  --wait

#Loki distributed
#helm install loki grafana/loki-distributed --version 0.80.0 -n obs -f ./values/loki-dis.yaml --wait

 helm install loki grafana/loki -f values/loki-dis.yaml -n obs --wait

#Instalação do OTEL

helm upgrade --install my-opentelemetry-collector open-telemetry/opentelemetry-collector --set mode=deployment \
--set image.repository="otel/opentelemetry-collector-k8s" --set command.name="otelcol-k8s" -f ./values/open-collector.yaml --version 0.111.0 -n obs --wait

#Instalação do Tempo

helm upgrade --install tempo grafana/tempo -f ./values/tempo.yaml -n obs

#Reaplicar cluster-issuer
kubectl apply -f ./config/cluster-issuer.yaml