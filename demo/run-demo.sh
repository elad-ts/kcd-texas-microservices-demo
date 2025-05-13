#!/bin/bash

. demo-magic.sh

kubectl delete -f ../chaos-mesh/productcatalogservice_chaos.yaml
kubectl delete -f ../chaos-mesh/frontend_chaos.yaml

clear && cd ../ && pwd

pe "open https://4cj8ib5m2oxaptyy.cd.akuity.cloud/applications"

pe "kubectl get nodes"

pe "kubectl get pods -n microservices-demo"

pe "kubectl get svc -n microservices-demo"

STORE_URL=$(kubectl get ingress frontend-ingress -n microservices-demo -o jsonpath='{.status.loadBalancer.ingress[0].hostname}')
CHAOS_MESH_URL=$(kubectl get ingress chaos-dashboard-ingress -n chaos-mesh -o jsonpath='{.status.loadBalancer.ingress[0].hostname}')

open "http://${STORE_URL}"

pe "open https://github.com/elad-ts/kcd-texas-microservices-demo"

pe "kubectl get pods -n pl"

pe "open https://work.getcosmic.ai/live/clusters"

pe "kubectl get pods -n chaos-mesh"

pe "cat chaos-mesh/rbac.yaml"

pe "kubectl create token account-cluster-manager-ujvmw"

pe "open http://${CHAOS_MESH_URL}"

pe "ab -d -n 50 -c 10 http://${STORE_URL}/"

pe "cat chaos-mesh/productcatalogservice_chaos.yaml"

pe "kubectl apply -f chaos-mesh/productcatalogservice_chaos.yaml"

pe "ab -d -n 50 -c 10 http://${STORE_URL}/"

pe "kubectl delete -f chaos-mesh/productcatalogservice_chaos.yaml"

pe "ab -d -n 50 -c 10 http://${STORE_URL}/"

pe "cat chaos-mesh/frontend_chaos.yaml"

pe "kubectl apply -f chaos-mesh/frontend_chaos.yaml"

pe "ab -d -n 50 -c 10 http://${STORE_URL}/"

pe "open http://${STORE_URL} && clear"

pe "# ⚠️ Very strange behavior detected! ⚠️"
pe "# 🔍 Why 100ms delay = 1.1–1.8s latency? 🔍"

"./demo/pixie-latency-analysis.sh"

