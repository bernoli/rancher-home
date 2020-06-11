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
