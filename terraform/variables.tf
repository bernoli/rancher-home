variable "cluster-name" {
  description = " Cluster Name"
  default = "rancher-home"
}

variable "kubernetes-version" {
  description = " Version of hyperkube from https://hub.docker.com/r/rancher/hyperkube/tags"
  default = "v1.17.5-rancher1"
}

variable "org" {
  description = "Github org"
  default = "ams0"
}

variable "repo" {
  description = "Github repo"
  default = "rancher-home"
}

variable "endpoint" {
  description = "Kubernetes API endpoint"
  default = "cloud.stackmasters.com"
}

variable "tenant_id" {
  description = "Tenant ID for AAD auth"
  default = "a68cdba5-68a4-49a3-8a42-2823316db54f"
}

variable "apiserver-id" {
  description = "AppID for AAD server app"
  default = "5bd13b05-c17a-4589-8a61-f2185ab7831f"
}

variable "client_id" {
  description = "AppID for AAD client app"
  default = "009ed4ad-ce28-45b9-b1ec-e515fd4e3d25"
}