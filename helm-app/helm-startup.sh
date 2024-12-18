#!/bin/bash

# Starting deployment
echo "Starting deployment"

# Step 1: Install Prometheus using the kube-prometheus-stack chart
echo "Deploying Prometheus and Grafana"
helm upgrade --install prometheus prometheus-community/kube-prometheus-stack -f values.yaml

# Step 2: If you have a Helm chart for your Tweet app, deploy it:
echo "Deploying Tweet application"
helm install tweet-app ./tweet-app -f values.yaml
# Step 5: Deployment Complete
echo "Deployment Complete"
