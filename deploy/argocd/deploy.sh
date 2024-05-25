#!/bin/bash

NAMESPACE="argocd"

helm upgrade argocd ../../charts/argo-cd \
    --install --create-namespace --namespace "${NAMESPACE}" \
    -f values.yaml
