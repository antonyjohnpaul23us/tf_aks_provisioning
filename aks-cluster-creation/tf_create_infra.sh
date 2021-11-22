#!/bin/bash

echo "##!##!##!##!##!##!##!##!##!##!##!##!##!##!##!##!##!##!"
echo "### Environment Variables to be set prior to Execution"
echo "##!##!##!##!##!##!##!##!##!##!##!##!##!##!##!##!##!##!"
echo "###  aks_sp_tenant  -  The Azure Service Principal's Tenant ID"
echo "###  aks_sp_uid     -  The Azure Service Principal's Client ID"
echo "###  aks_sp_pwd     -  The Azure Service Principal's Tenant ID"
echo "###  aks_sp_tenant  -  Docker Hub's access Token for Pushing containers from jenkins"
echo "###  jenkins_admin_password  -  Jenkins admin password to set"


# AKS Cluster Creation
terraform -chdir="./tf_infraProv" init
terraform -chdir="./tf_infraProv" plan -var-file="../samplevars.tfvars" 
terraform -chdir="./tf_infraProv" apply -var-file="../samplevars.tfvars" --auto-approve

##terraform output -raw kube_config > aks_kubeconfig2
export KUBE_CONFIG_PATH=$(realpath ../tf_infraProv/aks_kubeconfig)
echo $KUBE_CONFIG_PATH

## Required for Kubernetes provider to access aks
az login --service-principal -u $aks_sp_uid -p $aks_sp_pwd --tenant $aks_sp_tenant
az aks get-credentials --resource-group "bb-aks-rg" --name cluster-bb-aks --file ./tf_infraProv/aks_kubeconfig --admin

# k8s resources Deployment
terraform -chdir="./tf_k8sResourceDeploy" init
terraform -chdir="./tf_k8sResourceDeploy" plan -var-file="../samplevars.tfvars"
terraform -chdir="./tf_k8sResourceDeploy" apply -var-file="../samplevars.tfvars" --auto-approve

# Cluster Issuer CRD & Jenkins Deployment
terraform -chdir="./tf_clusterIssuer_Jenkins" init 
terraform -chdir="./tf_clusterIssuer_Jenkins" apply -var-file="../samplevars.tfvars" -var jenkins_admin_password=$jenkins_admin_password --auto-approve

## Setting Up access to docker for pushing images from Jenkins
kubectl create secret docker-registry registry-credentials --docker-server=https://index.docker.io/v1/ --docker-username=antonyjohnpaul23usgmail --docker-password=$DOCKER_HUB_TOKEN --docker-email=antonyjohnpaul5us.general@gmail.com --kubeconfig=./tf_infraProv/aks_kubeconfig --namespace=jenkins

