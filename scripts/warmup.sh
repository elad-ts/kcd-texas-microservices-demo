#!/bin/bash

echo "===> Starting deployment of Online Boutique demo application..."
kubectl apply -f 'https://raw.githubusercontent.com/GoogleCloudPlatform/microservices-demo/refs/heads/main/release/kubernetes-manifests.yaml'
echo "===> Online Boutique demo application deployed. Getting frontend service URL..."
SITE_URL=$(kubectl get service frontend-external | awk '{print $4}')
echo "===> Frontend service URL: $SITE_URL"

echo "===> Cloning Pixie repository..."
git clone https://github.com/pixie-io/pixie.git
echo "===> Pixie repository cloned. Navigating to pixie directory..."
cd pixie
echo "===> In pixie directory."

echo "===> Finding latest Pixie cloud release..."
export LATEST_CLOUD_RELEASE=$(git tag | perl -ne 'print $1 if /release\/cloud\/v([^\-]*)$/' | sort -t '.' -k1,1nr -k2,2nr -k3,3nr | head -n 1)
echo "===> Latest Pixie cloud release: ${LATEST_CLOUD_RELEASE}"

echo "===> Checking out release version..."
git checkout "release/cloud/v${LATEST_CLOUD_RELEASE}"
echo "===> Updating kustomization file with correct version..."
perl -pi -e "s|newTag: latest|newTag: \"${LATEST_CLOUD_RELEASE}\"|g" k8s/cloud/public/kustomization.yaml
echo "===> Kustomization file updated."

echo "===> Installing mkcert certificates..."
/opt/homebrew/bin/mkcert -install
echo "===> mkcert certificates installed."
echo "===> Creating 'plc' namespace..."
kubectl create namespace plc
echo "===> 'plc' namespace created. Creating cloud secrets..."
./scripts/create_cloud_secrets.sh
echo "===> Cloud secrets created."

echo "===> Deploying Elastic operator..."
/opt/homebrew/bin/kustomize build k8s/cloud_deps/base/elastic/operator | kubectl apply -f -
echo "===> Elastic operator deployed. Deploying cloud dependencies..."
/opt/homebrew/bin/kustomize build k8s/cloud_deps/public | kubectl apply -f -
echo "===> Cloud dependencies deployed."

echo "===> Deploying Pixie cloud services..."
/opt/homebrew/bin/kustomize build k8s/cloud/public/ | kubectl apply -f -
echo "===> Pixie cloud services deployed."

echo "===> Checking pods in 'plc' namespace..."
kubectl get pods -n plc
echo "===> Pod status displayed."

echo "===> Getting cloud-proxy-service information..."
kubectl get service cloud-proxy-service -n plc
echo "===> Getting vzconn-service information..."
kubectl get service vzconn-service -n plc
echo "===> Service information displayed."

echo "===> Building DNS updater utility..."
go build src/utils/dev_dns_updater/dev_dns_updater.go
echo "===> DNS updater utility built."

echo "===> Updating DNS for Pixie development domain..."
echo "RUN: ./dev_dns_updater --domain-name="dev.withpixie.dev"  --kubeconfig=$HOME/.kube/config --n=plc "
read -k1 -s
echo "===> DNS updated for dev.withpixie.dev"

echo "===> Opening Pixie UI in browser..."
open 'https://dev.withpixie.dev'
echo "===> Setup complete! The Pixie UI should be opening in your browser."

export PX_CLOUD_ADDR=dev.withpixie.dev

px auth login

px deploy --dev_cloud_namespace plc

# Chaos mesh installation 
helm repo add chaos-mesh https://charts.chaos-mesh.org
kubectl create ns chaos-mesh
# Default to /var/run/docker.sock

helm install chaos-mesh chaos-mesh/chaos-mesh -n=chaos-mesh --set chaosDaemon.runtime=containerd --set chaosDaemon.socketPath=/run/containerd/containerd.sock --version 2.7.1

kubectl apply -f chaos_rbac.yaml

kubectl create token account-default-manager-wmrsn

open 'http://localhost:2333'
