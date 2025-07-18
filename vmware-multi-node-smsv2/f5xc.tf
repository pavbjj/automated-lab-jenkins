# Create SMSv2 objects
resource "volterra_securemesh_site_v2" "node-1" {
  name        = "${var.prefix}-smsv2-ha"
  namespace   = "system"
  description = var.description
  labels = {
    "ves.io/provider" = "ves-io-VMWARE",
  }

  block_all_services      = true
  logs_streaming_disabled = true
  enable_ha               = true

  lifecycle {
    ignore_changes = [labels]
  }
  re_select {
    geo_proximity = true
  }
  vmware {
    not_managed {
    }
  }
  load_balancing {
    vip_vrrp_mode = "VIP_VRRP_ENABLE"
  }
}

# Create SMSv2 tokens
resource "volterra_token" "node-1" {
  name        = "${var.prefix}-token-node-1"
  namespace   = "system"
  description = var.description
  type        = 1
  site_name   = volterra_securemesh_site_v2.node-1.name
  depends_on  = [volterra_securemesh_site_v2.node-1]
}

resource "volterra_token" "node-2" {
  name        = "${var.prefix}-token-node-2"
  namespace   = "system"
  description = var.description
  type        = 1
  site_name   = volterra_securemesh_site_v2.node-1.name
  depends_on  = [volterra_securemesh_site_v2.node-1]
}

resource "volterra_token" "node-3" {
  name        = "${var.prefix}-token-node-3"
  namespace   = "system"
  description = var.description
  type        = 1
  site_name   = volterra_securemesh_site_v2.node-1.name
  depends_on  = [volterra_securemesh_site_v2.node-1]
}