# count in module requires terraform 0.13
# change this to clusters/aks/ if you target AKS
module "cluster" {
    count   = var.cluster_type == "rke" ? 1 : 0

    source = "./clusters/rke"
    tenant_id = var.tenant_id
    apiserver-id = var.apiserver-id
}