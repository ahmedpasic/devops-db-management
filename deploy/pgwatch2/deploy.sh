#!/bin/bash

NAMESPACE="grafana"

helm template pgwatch2 ../../charts/pgwatch2 \
    --namespace "${NAMESPACE}" \
    -f values.yaml > tmp.yaml
