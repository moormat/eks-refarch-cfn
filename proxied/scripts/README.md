order of scripts to run:
1. apply-proxy-configmap will configure proxy on kube-proxy and coredns
2. aws-auth.sh will add the worker node IAM Role to the cluster RBAC
3. helm-init.sh will install popular cluster addons cluster-autoscaler, alb-ingress-controller, metrics-server, prometheus-operator
