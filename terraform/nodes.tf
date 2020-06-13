# Definition of nodes for the RKE cluster
locals {
  nodes = {
    "nuc1"   = "192.168.178.5"
    "nuc2"   = "192.168.178.6"
    "box"   = "192.168.178.9"
  }
}