#!/bin/bash
set -o xtrace

cp proxy-environment-variables.template.yaml proxy-environment-variables.yaml


SERVICEIP=$(kubectl get service kubernetes --no-headers | awk '{print $3}')

CLUSTERIPCIDR="172.20.0.0/16"
if [[ $SERVICEIP == "10"* ]]; then
  CLUSTERIPCIDR="10.100.0.0/16"
fi

sed -i '' "s#CLUSTERIPCIDR#$CLUSTERIPCIDR#g" proxy-environment-variables.yaml


VPCCIDR=172.28.0.0/16
if [[ ! -z $1 ]]; then
  #argument 1 overrides default vpc cidr
  VPCCIDR=$1
fi
sed -i '' "s#VPCCIDR#$VPCCIDR#g" proxy-environment-variables.yaml


PROXYADDR=http://squidproxy.internal:3128
if [[ ! -z $2 ]]; then
  #argument 2 overrides default proxy url
  PROXYADDR=$2
fi
sed -i '' "s#PROXYADDR#$PROXYADDR#g" proxy-environment-variables.yaml

kubectl apply -f proxy-environment-variables.yaml

kubectl patch -n kube-system  -p '{ "spec": {"template": { "spec": { "containers": [ { "name": "aws-node", "envFrom": [ { "configMapRef": {"name": "proxy-environment-variables"} } ] } ] } } } }' daemonset aws-node

kubectl patch -n kube-system  -p '{ "spec": {"template": { "spec": { "containers": [ { "name": "kube-proxy", "envFrom": [ { "configMapRef": {"name": "proxy-environment-variables"} } ] } ] } } } }' daemonset kube-proxy
