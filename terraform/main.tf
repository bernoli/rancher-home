# change this to clusters/aks/ if you target AKS
module "cluster" {
    source = "./clusters/rke/"
    tenant_id = var.tenant_id
    apiserver-id = var.apiserver-id
}