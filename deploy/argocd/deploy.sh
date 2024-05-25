#!/bin/bash

NAMESPACE="argocd"

helm upgrade argocd ../../charts/argo-cd \
    --install --create-namespace --namespace "${NAMESPACE}" \
    -f values.yaml

kubectl apply -f nodeport.yaml -n "${NAMESPACE}"
