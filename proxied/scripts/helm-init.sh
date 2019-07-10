#!/bin/bash
#initialize kubernetes cluster

set -o xtrace

#get cluster from env
CLUSTERNAME=$(kubectl config get-contexts | egrep '^\*' | awk '{split($2,x,"/");print x[2]}')

echo $CLUSTERNAME

#helm
#needs rbac-config.yaml
cat << EOF > ./rbac-config.yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: tiller
  namespace: kube-system
---
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: tiller
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: cluster-admin
subjects:
  - kind: ServiceAccount
    name: tiller
    namespace: kube-system

EOF

kubectl apply -f rbac-config.yaml
helm init --service-account=tiller --history-max 200

#alb ingress controller
helm repo add incubator http://storage.googleapis.com/kubernetes-charts-incubator

helm install incubator/aws-alb-ingress-controller --name alb-ingress-controller --set autoDiscoverAwsRegion=true --set autoDiscoverAwsVpcID=true --set clusterName=$CLUSTERNAME

# cluster autoscaler
helm install stable/cluster-autoscaler --name cluster-autoscaler --set cloudProvider=aws --set autoDiscovery.clusterName=$CLUSTERNAME --set awsRegion=us-west-2 --set sslCertHostPath='/etc/kubernetes/pki/ca.crt' --set rbac.create=true --set rbac.pspEnabled=true

# prometheus operator
helm install stable/prometheus-operator --name prometheus-operator

# metrics server
helm install stable/metrics-server --name metrics-server --set rbac.create=true --set rbac.pspEnabled=True --set args[0]='--kubelet-preferred-address-types=InternalIP'