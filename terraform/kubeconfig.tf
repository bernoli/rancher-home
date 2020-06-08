resource "local_file" "kube_cluster_yaml" {
  filename = "~/.kube/config"
  content  = rke_cluster.cluster.kube_config_yaml
}