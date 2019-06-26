#!/bin/bash
#use name of parent stack as first argument
PARENTSTACKNAME=$1

CLUSTERNAME=$(kubectl config get-contexts | egrep '^\*' | awk '{split($2,x,"/");print x[2]}')
echo using Cluster: $CLUSTERNAME

NODEROLE=$(aws cloudformation describe-stacks --stack-name $(aws cloudformation describe-stack-resources --stack-name $PARENTSTACKNAME | jq -r '.StackResources[] | select(.LogicalResourceId | contains ("NodeInstanceProfileStack")).PhysicalResourceId') | jq -r '.Stacks[].Outputs[] | select (.OutputKey | contains("NodeInstanceRole")).OutputValue')
echo using Worker Node IAM Role: $NODEROLE

cat << EOF > aws-auth-cm.yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: aws-auth
  namespace: kube-system
data:
  mapRoles: |
    - rolearn: $NODEROLE
      username: system:node:{{EC2PrivateDNSName}}
      groups:
        - system:bootstrappers
        - system:nodes

EOF

cat aws-auth-cm.yaml
kubectl apply -f aws-auth-cm.yaml --v=4
rm aws-auth-cm.yaml

