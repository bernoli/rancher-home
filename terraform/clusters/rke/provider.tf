# tf 0.13 uses a different approach to plugin location
# create a folder and copy the rke provider in it: .terraform/plugins/terraform.example.com/rancher/rke/1.0.0/linux_amd64/terraform-provider-rke_1.0.0
# doesn't seem to work with ~/.terraform.d/plugins folder

terraform {
  required_providers {
    rke = {
      source  = "terraform.example.com/rancher/rke"
      version = "1.0.0"
    }
  }
}