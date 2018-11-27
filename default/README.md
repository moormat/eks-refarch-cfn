Example CloudFormation Nested Stack Architecture for Elastic Kubernetes Service

Requirements:

S3 Bucket for Storage of Nested Stacks
- place the following template files into an S3 Bucket you have access to:

1. vpc.yaml
2. ekscluster.yaml			
3. workernodeinstanceprofile.yaml
4. workernodesecuritygroup.yaml
5. nodegroup1.yaml
6. nodegroup2.yaml

- create a new CloudFormation Stack using parent.yaml
- you *must* create the parent stack using the IAM Credentials you want to access the APIServer Endpoint with!
- set parameters as desired

$ aws cloudformation create-stack --stack-name ExampleEKS --parameters file://./parentparameters.json --template-body file://./parent.yaml --capabilities CAPABILITY_IAM


Example Parent Stack Parameters

```json

[
    {
        "ParameterKey": "BootstrapArguments1",
        "ParameterValue": ""
    },
    {
        "ParameterKey": "BootstrapArguments2",
        "ParameterValue": ""
    },
    {
        "ParameterKey": "ClusterName",
        "ParameterValue": "TestCluster"
    },
    {
        "ParameterKey": "ClusterVersion",
        "ParameterValue": "1.10"
    },
    {
        "ParameterKey": "KeyName1",
        "ParameterValue": "test-ssh-key"
    },
    {
        "ParameterKey": "KeyName2",
        "ParameterValue": "test-ssh-key"
    },
    {
        "ParameterKey": "NodeAutoScalingGroupMaxSize1",
        "ParameterValue": "1"
    },
    {
        "ParameterKey": "NodeAutoScalingGroupMinSize1",
        "ParameterValue": "1"
    },
    {
        "ParameterKey": "NodeGroupName1",
        "ParameterValue": "t2mediumnodegroup"
    },
    {
        "ParameterKey": "NodeImageId1",
        "ParameterValue": "ami-0a54c984b9f908c81"
    },
    {
        "ParameterKey": "NodeInstanceType1",
        "ParameterValue": "t2.medium"
    },
    {
        "ParameterKey": "NodeVolumeSize1",
        "ParameterValue": "40"
    },
    {
        "ParameterKey": "NodeAutoScalingGroupMaxSize2",
        "ParameterValue": "3"
    },
    {
        "ParameterKey": "NodeAutoScalingGroupMinSize2",
        "ParameterValue": "1"
    },
    {
        "ParameterKey": "NodeGroupName2",
        "ParameterValue": "t2smallnodegroup"
    },
    {
        "ParameterKey": "NodeImageId2",
        "ParameterValue": "ami-0a54c984b9f908c81"
    },
    {
        "ParameterKey": "NodeInstanceType2",
        "ParameterValue": "t2.small"
    },
    {
        "ParameterKey": "NodeVolumeSize2",
        "ParameterValue": "20"
    },
    {
        "ParameterKey": "S3BucketName",
        "ParameterValue": "<Bucket Name>"
    },
    {
        "ParameterKey": "ServiceRole",
        "ParameterValue": "arn:aws:iam::123456789012:role/EKS-Service-Role"
    },
    {
        "ParameterKey": "Subnet01Block",
        "ParameterValue": "192.168.32.0/19"
    },
    {
        "ParameterKey": "Subnet02Block",
        "ParameterValue": "192.168.64.0/19"
    },
    {
        "ParameterKey": "Subnet03Block",
        "ParameterValue": "192.168.96.0/19"
    },
    {
        "ParameterKey": "Subnet04Block",
        "ParameterValue": "192.168.128.0/19"
    },
    {
        "ParameterKey": "Subnet05Block",
        "ParameterValue": "192.168.160.0/19"
    },
    {
        "ParameterKey": "Subnet06Block",
        "ParameterValue": "192.168.192.0/19"
    },
    {
        "ParameterKey": "VpcBlock",
        "ParameterValue": "192.168.0.0/16"
    }
]

```


- At the end of this process you will have a running EKS Cluster and you can apply the configmap to authorize the Worker Node IAM Role
