# Create SMSv2 objects
resource "volterra_securemesh_site_v2" "node-1" {
  name        = "${var.prefix}-smsv2-node-1"
  namespace   = "system"
  description = var.description
  labels = {
    "ves.io/provider" = "ves-io-VMWARE",
  }

  block_all_services      = true
  logs_streaming_disabled = true
  enable_ha               = false

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