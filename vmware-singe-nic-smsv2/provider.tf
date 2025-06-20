terraform {
  required_providers {
    volterra = {
      source  = "volterraedge/volterra"
      version = "0.11.43"
    }
  }
}

provider "vsphere" {
  allow_unverified_ssl = true
}

provider "volterra" {
  url          = var.volterra_config.url
  api_cert = var.api_cert
  api_key  = var.api_key
}
