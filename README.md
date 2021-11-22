# aks-jenkins-provisioning-through-terraform

### Create an AKS cluster in Azure using terraform and deploy Jenkins a sample application in the K8s Cluster using terraform and Helm charts

Application of Interest: https://tomcat.apache.org/tomcat-8.0-doc/appdev/sample/

## Getting started:
##### Prerequisites:
1) An Azure environment with permissions to deploy resources
2) Terraform cli installed locally.
3) A service principal that will be used by terraform
4) The below environment variables need to be set before running the terraform scripts 
- aks_sp_tenant  ----  The Azure Service Principal's Tenant ID
- aks_sp_uid  -----  The Azure Service Principal's Client ID
- aks_sp_pwd  ----  The Azure Service Principal's Tenant ID
- aks_sp_tenant  ----  Docker Hub's access Token for Pushing containers from Jenkins
- jenkins_admin_password  ----  Jenkins admin password to set

To build the environment and deploy jenkins, the [tf_create_infra.sh](https://github.com/antonyjohnpaul23us/tf_aks_provisioning/blob/feature1/aks-cluster-creation/tf_create_infra.sh) file can be executed after setting the environment variables.
## Navigating the Repo:
#

### Terraform Root Modules
The provisioning terraform script consists of three blocks ([tf_create_infra.sh](https://github.com/antonyjohnpaul23us/tf_aks_provisioning/blob/feature1/aks-cluster-creation/tf_create_infra.sh)):
    - Creation of AKS and it's dependent Azure Infrastructure Resources
    - Creation of namespaces, nginx ingress and cert manager to secure ingress endpoints
    - Deployment of ClusterIssuer CRD and configuring ACME server URL to Let's encrypt Production certificated for auto-generating tls certificates.
The [tf_create_infra.sh](https://github.com/antonyjohnpaul23us/tf_aks_provisioning/blob/feature1/aks-cluster-creation/tf_create_infra.sh) file can be used to create the infrastructure once the prerequisite environment variables are set

__Note__: Parameterization has been cone to support the immediate requirement but can be scaled put. If this needs to be deployed into a different environment, ensure that the name / dns_name / resource_group are updated in the samplevars.tfvars or in the shell script as cli arguments to overwrite the defaults.

### Terraform Scripts
The terraform logic is largely encapsulated within a modules section that enables further enhancement and consumption across business verticals and reusability based on the need for AKS or other cloud Infrastructures. Publicly available helm charts have been modified to cater the present need and hence stored in the location([infra-tf-commonlibs-git](https://github.com/antonyjohnpaul23us/tf_aks_provisioning/tree/feature1/infra-tf-commonlibs-git)).

__Note:__ Cluster resources in AKS cannot be immediately deployed into the cluster as soon as it is created as it will take a few minutes to be fully functions. time_sleep resources have been embedded in the terraform script as required.
### Helm Charts
Helm charts have been used to install/deploy the following components in the Kubernetes Cluster
    - nginx Ingress Controller
    - cert-manager
    - Jenkins Server (with CasC for required components & Secrets)
    - Sample Application ( The sample application's Helm values are stores as part of the sample app codebase ([bb-sample-app](https://github.com/antonyjohnpaul23us/bb-sample-app)))
    
Most of the helm charts used are stock. However, the Jenkins chart has been modified to support specific requirements, hence it is stored in the repository and deployed from within the repo.
    

