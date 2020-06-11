provider "azuread" {
  tenant_id = "a68cdba5-68a4-49a3-8a42-2823316db54f"
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
    server: https://cloud.stackmasters.com:6443
  name: rkeaad
contexts:
- context:
    cluster: rkeaad
    namespace: default
    user: 404f30c4-903f-49f4-9aa6-1f909e25747f
  name: rkeaad
current-context: rkeaad
kind: Config
preferences: {}
users:
- name: 404f30c4-903f-49f4-9aa6-1f909e25747f
  user:
    auth-provider:
      config:
        apiserver-id: 5bd13b05-c17a-4589-8a61-f2185ab7831f
        client-id: 009ed4ad-ce28-45b9-b1ec-e515fd4e3d25
        environment: AzurePublicCloud
        tenant-id: a68cdba5-68a4-49a3-8a42-2823316db54f
      name: azure
  EOT
}

resource "local_file" "kubeconfig_aad" {
  filename = "kubeconfig_aad.yaml"
  content  = local.kubeconfig_aad
}