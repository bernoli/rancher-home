#Sets up a Cluster role binding to grant a specific AAD group cluster-admin role and creates a generic kubeconfig for AAD auth

provider "azuread" {
  tenant_id = var.tenant_id
}

data "azuread_user" "alessandro" {
  user_principal_name = "alessandro@cookingwithazure.com"
}

data "azuread_group" "kubernetes-admin" {
  name = "kubernetes-admin"
}

resource "kubernetes_cluster_role_binding" "rke-cluster-admins" {
  metadata {
    name = "rke-cluster-admins"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "cluster-admin"
  }
  subject {
    kind      = "Group"
    name      = data.azuread_group.kubernetes-admin.id
    api_group = "rbac.authorization.k8s.io"
  }
}

locals {
  kubeconfig_aad = <<-EOT
apiVersion: v1
clusters:
- cluster:
    certificate-authority-data: ${base64encode(rke_cluster.cluster.ca_crt)}
    server: https://${var.endpoint}:6443
  name: rkeaad
contexts:
- context:
    cluster: rkeaad
    namespace: default
    user: ${data.azuread_user.alessandro.id}
  name: rkeaad
current-context: rkeaad
kind: Config
preferences: {}
users:
- name: ${data.azuread_user.alessandro.id}
  user:
    auth-provider:
      config:
        apiserver-id: ${var.apiserver-id}
        client-id: ${var.client_id}
        environment: AzurePublicCloud
        tenant-id: ${var.tenant_id}
      name: azure
  EOT
}

resource "local_file" "kubeconfig_aad" {
  filename = "kubeconfig_aad.yaml"
  content  = local.kubeconfig_aad
}