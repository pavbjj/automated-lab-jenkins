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
  api_p12_file = var.volterra_config.api_p12_file
  url          = var.volterra_config.url
  api_cert = var.api_cert
  api_key  = var.api_key
}
