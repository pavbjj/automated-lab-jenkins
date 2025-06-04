terraform {
  required_providers {
    volterra = {
      source  = "volterraedge/volterra"
      version = "0.11.43"
    }
  }
}

provider "volterra" {
  timeout      = "90s"
  api_p12_file = "secrets/p12.p12"
  url          = var.url
}

resource "volterra_azure_vnet_site" "azure_site" {
  name      = var.azure_site_name
  namespace = "system"

  azure_cred {
    name      = "p-kuligowski-az-cc"
    namespace = "system"
  }
  vnet {
    existing_vnet {
      vnet_name         = var.existing_vnet_name
      resource_group = var.vnet_resource_group
      manual_routing    = true
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
      azure_az  = "1"
      outside_subnet {
        subnet {
            subnet_name = "outside-subnet"
            vnet_resource_group = true
          
        }
      }
     inside_subnet {
        subnet {
            subnet_name = "inside-subnet"
            vnet_resource_group = true
          
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
