#!/bin/bash

set -e

ENV_ID=${1}

WORKDIR="$(dirname "${BASH_SOURCE[0]:-$0}")/"
cd "${WORKDIR}" || exit 1

if [ -f "pgwatch-secrets.sh" ]
then
  echo "Sourcing pgwatch-secrets.sh"
  . "pgwatch-secrets.sh"
elif [ -n "${ENV_ID}" ] && [ -f "pgwatch-secrets-${ENV_ID}.sh" ]
then
  echo "Sourcing i3-access-secrets-${ENV_ID}.sh"
  . "pgwatch-secrets-${ENV_ID}.sh"
fi

function randAlphaNum() {
  local LENGTH=${1}
  local TARGET_VAR=${2}

  if [ -z "${LENGTH}" ] || [ -z "${TARGET_VAR}" ]
  then
    echo "Usage: randAlphaNum LENGTH TARGET_VAR"
    echo "Example randAlphaNum 16 COOKIE_KEY"
    return 1;
  fi

  local RESULT=$(cat /dev/urandom | LC_ALL=C tr -dc 'a-zA-Z0-9' | fold -w "${LENGTH}" | head -n 1)
  eval ${TARGET_VAR}="${RESULT}";
}

randAlphaNum 32 INFLUXDB_PASSWORD

kubectl create secret generic pgwatch2-secret --dry-run=client -o yaml \
        --from-literal=pgwatch2-adhoc-config=${PGWATCH2_ADHOC_CONFIG} \
        --from-literal=pgwatch2-adhoc-str=${PGWATCH2_ADHOC_STR} \
        --from-literal=pgwatch2-ihost=${PGWATCH2_IHOST} \
        --from-literal=pgwatch2-iport=${PGWATCH2_IPORT} \
        --from-literal=pgwatch2-issl=${PGWATCH2_ISSL} \
        --from-literal=pgwatch2-verbose=${PGWATCH2_VERBOSE} | kubectl \
        label -f - --dry-run=client -o yaml --local \
        chart=pgwatch2-helm \
        name=pgwatch2 \
        release=pgwatch2 > pgwatch2-secrets.yaml

kubectl create secret generic influxdb-auth --dry-run=client -o yaml \
        --from-literal=influxdb-db=${INFLUXDB_DB} \
        --from-literal=influxdb-dbname=${INFLUXDB_DBNAME} \
        --from-literal=influxdb-user=${INFLUXDB_USER} \
        --from-literal=influxdb-password=${INFLUXDB_PASSWORD} | kubectl \
        label -f - --dry-run=client -o yaml --local \
        chart=pgwatch2-helm \
        name=pgwatch2 \
        release=pgwatch2 > influxdb-auth.yaml

echo "Secrets templates are created. First, specify the wanted kubectl context with the folowing command:"
echo "kubectl config use-context <CONTEXT_NAME>"
echo "After that, create the secrets in your cluster with the following commands:"
echo "kubectl apply -f pgwatch2-secrets.yaml -n grafana"
echo "kubectl apply -f influxdb-auth.yaml -n grafana"
