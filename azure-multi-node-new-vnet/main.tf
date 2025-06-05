terraform {
  required_providers {
    volterra = {
      source  = "volterraedge/volterra"
      version = "0.11.43"
    }
  }
}

provider "volterra" {
  timeout  = "90s"
  url      = var.url
  api_cert = var.api_cert
  api_key  = var.api_key
}

resource "volterra_azure_vnet_site" "azure_site" {
  name      = var.azure_site_name
  namespace = "system"

  azure_cred {
    name      = "p-kuligowski-az-cc"
    namespace = "system"
  }
  vnet {
    new_vnet {
      primary_ipv4 = "10.1.0.0/24"
    }
  }

  logs_streaming_disabled = true
  azure_region            = var.azure_region
  resource_group          = var.azure_site_rg
  disk_size               = "80"
  machine_type            = "Standard_D3_v2"


  ingress_egress_gw {
    azure_certified_hw       = "azure-byol-multi-nic-voltmesh"
    no_global_network        = true
    no_outside_static_routes = true
    no_inside_static_routes  = false
    no_network_policy        = true
    no_forward_proxy         = false
    forward_proxy_allow_all  = true

    az_nodes {
      azure_az = "1"
      outside_subnet {
        subnet_param {
          ipv4 = "10.1.1.0/24"
        }
      }
      inside_subnet {
        subnet_param {
          ipv4 = "10.1.2.0/24"

        }
      }
    }
    az_nodes {
      azure_az = "2"
      outside_subnet {
        subnet_param {
          ipv4 = "10.1.3.0/24"
        }
      }
      inside_subnet {
        subnet_param {
          ipv4 = "10.1.4.0/24"

        }
      }
    }
    az_nodes {
      azure_az = "3"
      outside_subnet {
        subnet_param {
          ipv4 = "10.1.5.0/24"
        }
      }
      inside_subnet {
        subnet_param {
          ipv4 = "10.1.6.0/24"

        }
      }
    }
  }

  blocked_services {
    blocked_sevice {
      ssh = true
      dns = true
    }
  }
  ssh_key = var.ssh_key
  lifecycle {
    ignore_changes = [labels]
  }
}

# resource "volterra_cloud_site_labels" "labels" {
#   name      = volterra_azure_vnet_site.azure_site.name
#   site_type = "azure_vnet_site"
#   labels = {
#     siteName       = var.siteName
#   }
#   ignore_on_delete = true
# }

resource "volterra_tf_params_action" "apply_azure_vnet" {
  site_name        = volterra_azure_vnet_site.azure_site.name
  site_kind        = "azure_vnet_site"
  action           = "apply"
  wait_for_action  = true
  ignore_on_update = true
}
