#!/bin/bash

NAMESPACE="pg"

helm upgrade postgresql ../../charts/postgresql \
    --install --create-namespace --namespace "${NAMESPACE}" \
    -f values.yaml

kubectl apply -f nodeport.yaml -n "${NAMESPACE}"
