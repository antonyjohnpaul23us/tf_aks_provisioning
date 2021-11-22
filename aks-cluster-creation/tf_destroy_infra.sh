#!/bin/bash

## Deleting resources created
terraform -chdir="./tf_clusterIssuer_Jenkins" init
terraform -chdir="./tf_clusterIssuer_Jenkins" destroy -var-file="../samplevars.tfvars" --auto-approve

terraform -chdir="./tf_k8sResourceDeploy" init
terraform -chdir="./tf_k8sResourceDeploy" destroy -var-file="../samplevars.tfvars" --auto-approve

terraform -chdir="./tf_infraProv" init
terraform -chdir="./tf_infraProv" destroy -var-file="../samplevars.tfvars" --auto-approve
