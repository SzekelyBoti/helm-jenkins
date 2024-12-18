#!/bin/bash

echo "Starting deployment"

echo "Applying Kubernetes configs"

kubectl apply -f prometheus-deployment.yaml
kubectl apply -f prometheus-service.yaml
kubectl apply -f prometheus-config.yaml
kubectl apply -f grafana-deployment.yaml
kubectl apply -f grafana-service.yaml
kubectl apply -f tweet-deployment.yaml
kubectl apply -f tweet-service.yaml
kubectl apply -f nginx-configmap.yaml

echo "Deployment Complete"
