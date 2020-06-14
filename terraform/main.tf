# count in module requires terraform 0.13
# change this to clusters/aks/ if you target AKS
module "cluster" {
  count = var.cluster_type == "rke" ? 1 : 0

  source       = "./modules/clusters/rke"
  tenant_id    = var.tenant_id
  aadserverapp_id = var.aadserverapp_id
}

module "aad" {
  source          = "./modules/aad"
  username        = var.username
  domain          = var.domain
  tenant_id       = var.tenant_id
  endpoint        = var.endpoint
  aadserverapp_id = var.aadserverapp_id
  aadclientapp_id = var.aadclientapp_id
  aadadmin_group  = var.aadadmin_group
  cluster_name    = module.cluster[0].cluster_name
  api_server_url  = module.cluster[0].api_server_url
  kube_admin_user = module.cluster[0].kube_admin_user
  client_cert     = module.cluster[0].client_cert
  client_key      = module.cluster[0].client_key
  ca_crt          = module.cluster[0].ca_crt
  aad_depends_on  = module.cluster[0].cluster_name

}

module "github" {
  source = "./modules/github"
}
module "flux" {
  source          = "./modules/flux"
  api_server_url  = module.cluster[0].api_server_url
  kube_admin_user = module.cluster[0].kube_admin_user
  client_cert     = module.cluster[0].client_cert
  client_key      = module.cluster[0].client_key
  ca_crt          = module.cluster[0].ca_crt
  identity        = module.github.private_key_pem

  namespace_depends_on = module.cluster[0].cluster_name
  secret_depends_on    = module.github.private_key_pem
}