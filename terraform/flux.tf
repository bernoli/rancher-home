provider "helm" {
  kubernetes {
    load_config_file = "false"


    host     = rke_cluster.cluster.api_server_url
    username = rke_cluster.cluster.kube_admin_user

    client_certificate     = rke_cluster.cluster.client_cert
    client_key             = rke_cluster.cluster.client_key
    cluster_ca_certificate = rke_cluster.cluster.ca_crt
  }
}

provider kubernetes {
  load_config_file = "false"


  host     = rke_cluster.cluster.api_server_url
  username = rke_cluster.cluster.kube_admin_user

  client_certificate     = rke_cluster.cluster.client_cert
  client_key             = rke_cluster.cluster.client_key
  cluster_ca_certificate = rke_cluster.cluster.ca_crt
}

resource "kubernetes_namespace" "fluxcd" {
  metadata {
    name = "fluxcd"
  }
}

resource "kubernetes_secret" "flux-ssh" {
  metadata {
    name      = "flux-ssh"
    namespace = kubernetes_namespace.fluxcd.metadata.0.name
  }
  data = {
    identity = tls_private_key.flux-deploy-key.private_key_pem
  }
}




resource "helm_release" "flux" {
  name       = "flux"
  repository = "https://charts.fluxcd.io"
  namespace  = "fluxcd"
  chart      = "flux"

  set {
    name  = "git.url"
    value = "git@github.com:ams0/rancher-home"
  }

  set {
    name  = "git.readonly"
    value = "false"
  }
  set {
    name  = "git.secretName"
    value = "flux-ssh"
  }
  set {
    name  = "sync.state"
    value = "git"
  }


  set {
    name  = "git.path"
    value = "manifests"
  }

  set {
    name  = "git.pollInterval"
    value = "1m"
  }

  set {
    name  = "syncGarbageCollection.enabled"
    value = "true"
  }
}

resource "helm_release" "helmoperatorcrds" {
  name       = "helmoperatorcrds"
  repository = "../charts/"
  chart      = "helmoperatorcrds"
}

resource "helm_release" "helm-operator" {

  depends_on = [
    helm_release.helmoperatorcrds,
  ]

  name       = "helm-operator"
  repository = "https://charts.fluxcd.io"
  namespace  = "fluxcd"
  chart      = "helm-operator"

  set {
    name  = "helm.versions"
    value = "v3"
  }

  set {
    name  = "configureRepositories.repositories[0].url"
    value = "https://kubernetes-charts.storage.googleapis.com"
  }

  set {
    name  = "configureRepositories.repositories[0].name"
    value = "stable"
  }


  set {
    name  = "configureRepositories.enable"
    value = "true"
  }

  set {
    name  = "git.ssh.secretName"
    value = "flux-ssh"
  }

}
