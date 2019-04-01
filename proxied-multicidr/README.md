Proxied Environment for EKS Cluster

* Uses a Fargate Service running "Squid" to provide the web proxy

* External Requirements: Create a Docker Image for web proxy
    * This is specified in the Stack Parameters: ProxyServiceImage ProxyServiceImageTag





   {
        "ParameterKey": "ProxyServiceImage",
        "ParameterValue": "123456789012.dkr.ecr.us-west-2.amazonaws.com/mysquidproxyimage"
    },
    {
        "ParameterKey": "ProxyServiceImageTag",
        "ParameterValue": "latest"
    }

