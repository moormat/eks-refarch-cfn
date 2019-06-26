#!/bin/bash
set -o xtrace

kubectl apply -f proxy-environment-variables.yaml

kubectl patch -n kube-system  -p '{ "spec": {"template": { "spec": { "containers": [ { "name": "aws-node", "envFrom": [ { "configMapRef": {"name": "proxy-environment-variables"} } ] } ] } } } }' daemonset aws-node

kubectl patch -n kube-system  -p '{ "spec": {"template": { "spec": { "containers": [ { "name": "kube-proxy", "envFrom": [ { "configMapRef": {"name": "proxy-environment-variables"} } ] } ] } } } }' daemonset kube-proxy