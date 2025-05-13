#!/bin/bash
# Script to manually simulate pod-kill for demo purposes
# This is a workaround for permission issues with Chaos Mesh

echo "Getting current Redis deployment info..."
DEPLOYMENT="redis-cart"
NAMESPACE="default"
REPLICAS=$(kubectl get deployment $DEPLOYMENT -n $NAMESPACE -o jsonpath='{.spec.replicas}')

echo "Current $DEPLOYMENT replicas: $REPLICAS"
echo "Simulating pod failure by scaling to 0..."
kubectl scale deployment $DEPLOYMENT -n $NAMESPACE --replicas=0

echo "Waiting 60 seconds for disruption to be observed..."
echo "During this time, monitor Pixie to see service disruption..."
sleep 60

echo "Restoring deployment to original replica count: $REPLICAS"
kubectl scale deployment $DEPLOYMENT -n $NAMESPACE --replicas=$REPLICAS

echo "Done. The deployment should recover shortly. Monitor Pixie to observe recovery." 