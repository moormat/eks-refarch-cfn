#!/bin/bash
aws cloudformation create-stack --stack-name proxydemo --template-body file://./proxy-parent.yaml --parameters file://./parentparameters.json --capabilities CAPABILITY_IAM --tags='Key=auto-delete,Value=no'
