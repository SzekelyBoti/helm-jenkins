#!/bin/bash

# Starting deployment
echo "Starting deployment"

echo "Deploying Prometheus and Grafana"
helm upgrade --install prometheus prometheus-community/kube-prometheus-stack -f values.yaml

echo "Deploying Tweet application"
helm install tweet-app ./tweet-app -f values.yaml
echo "Deployment Complete"
