#!/bin/bash
set -e

# 1. Apply the Argo CD Application
 kubectl apply -f ./pixie-demo/online-boutique-app.yaml

echo "Setup complete! Resources created:"
echo "Next steps:"
echo "1. Wait for application to sync in Akuity/Argo CD"
echo "2. Open Pixie UI: px live px/cluster"
echo "3. Follow the demo script for the walkthrough" 