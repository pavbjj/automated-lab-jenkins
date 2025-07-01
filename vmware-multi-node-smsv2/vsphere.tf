data "vsphere_ovf_vm_template" "ovf-template" {
  name              = "ovf-template"
  disk_provisioning = "flat"
  resource_pool_id  = data.vsphere_compute_cluster.cluster.resource_pool_id
  datastore_id      = data.vsphere_datastore.datastore.id
  host_system_id    = data.vsphere_host.host1.id
  remote_ovf_url    = var.cluster_config.shared.ova_url
}

resource "vsphere_virtual_machine" "node1" {
  name                 = format("%s-%s", var.vsphere_config.virtual_machine_prefix, var.cluster_config.node1.hostname)
  datacenter_id        = data.vsphere_datacenter.datacenter.id
  datastore_id         = data.vsphere_datastore.datastore.id
  host_system_id       = data.vsphere_host.host1.id
  resource_pool_id     = data.vsphere_compute_cluster.cluster.resource_pool_id
  num_cpus             = var.num_cpus
  num_cores_per_socket = 1
  memory               = var.memory
  guest_id             = data.vsphere_ovf_vm_template.ovf-template.guest_id
  scsi_type            = data.vsphere_ovf_vm_template.ovf-template.scsi_type
  nested_hv_enabled    = data.vsphere_ovf_vm_template.ovf-template.nested_hv_enabled
  folder               = trimprefix(data.vsphere_folder.folder.path, "/${data.vsphere_datacenter.datacenter.name}/vm")

  network_interface {
    network_id  = data.vsphere_network.outside.id
    ovf_mapping = "OUTSIDE"
  }

  network_interface {
    network_id  = data.vsphere_network.inside.id
    ovf_mapping = "INSIDE"
  }

  disk {
    label          = "disk0"
    size           = 80
    unit_number    = 0
    io_share_count = 1000

  }

  wait_for_guest_net_timeout = 0
  wait_for_guest_ip_timeout  = 0

  ovf_deploy {
    allow_unverified_ssl_cert = true
    remote_ovf_url            = data.vsphere_ovf_vm_template.ovf-template.remote_ovf_url
    disk_provisioning         = data.vsphere_ovf_vm_template.ovf-template.disk_provisioning
  }

  vapp {
    properties = {
      "guestinfo.hostname"  = var.cluster_config.node1.hostname
      "guestinfo.ves.token" = volterra_token.node-1.id
      "guestinfo.ves.adminpassword" : var.cluster_config.shared.admin_password
      "guestinfo.interface.0.dhcp"                = "no"
      "guestinfo.interface.0.ip.0.address"        = var.cluster_config.node1.addresses.outside
      "guestinfo.interface.0.route.0.gateway"     = var.cluster_config.node1.route.gateway
      "guestinfo.interface.0.route.0.destination" = var.cluster_config.node1.route.destination
      "guestinfo.dns.server.0"                    = var.cluster_config.shared.dns_server1
      "guestinfo.dns.server.1"                    = var.cluster_config.shared.dns_server2
    }
  }
  depends_on = [
    volterra_token.node-1,
    volterra_securemesh_site_v2.node-1
    ]

  lifecycle {
    ignore_changes = [
      vapp[0].properties["guestinfo.hostname"],
      vapp[0].properties["guestinfo.ves.adminpassword"]
    ]
  }
}

resource "vsphere_virtual_machine" "node2" {
  name                 = format("%s-%s", var.vsphere_config.virtual_machine_prefix, var.cluster_config.node2.hostname)
  datacenter_id        = data.vsphere_datacenter.datacenter.id
  datastore_id         = data.vsphere_datastore.datastore.id
  host_system_id       = data.vsphere_host.host1.id
  resource_pool_id     = data.vsphere_compute_cluster.cluster.resource_pool_id
  num_cpus             = var.num_cpus
  num_cores_per_socket = 1
  memory               = var.memory
  guest_id             = data.vsphere_ovf_vm_template.ovf-template.guest_id
  scsi_type            = data.vsphere_ovf_vm_template.ovf-template.scsi_type
  nested_hv_enabled    = data.vsphere_ovf_vm_template.ovf-template.nested_hv_enabled
  folder               = trimprefix(data.vsphere_folder.folder.path, "/${data.vsphere_datacenter.datacenter.name}/vm")

  network_interface {
    network_id  = data.vsphere_network.outside.id
    ovf_mapping = "OUTSIDE"
  }

  network_interface {
    network_id  = data.vsphere_network.inside.id
    ovf_mapping = "INSIDE"
  }

  disk {
    label          = "disk0"
    size           = 80
    unit_number    = 0
    io_share_count = 1000

  }

  wait_for_guest_net_timeout = 0
  wait_for_guest_ip_timeout  = 0

  ovf_deploy {
    allow_unverified_ssl_cert = true
    remote_ovf_url            = data.vsphere_ovf_vm_template.ovf-template.remote_ovf_url
    disk_provisioning         = data.vsphere_ovf_vm_template.ovf-template.disk_provisioning
  }

  vapp {
    properties = {
      "guestinfo.hostname"  = var.cluster_config.node1.hostname
      "guestinfo.ves.token" = volterra_token.node-2.id
      "guestinfo.ves.adminpassword" : var.cluster_config.shared.admin_password
      "guestinfo.interface.0.dhcp"                = "no"
      "guestinfo.interface.0.ip.0.address"        = var.cluster_config.node1.addresses.outside
      "guestinfo.interface.0.route.0.gateway"     = var.cluster_config.node1.route.gateway
      "guestinfo.interface.0.route.0.destination" = var.cluster_config.node1.route.destination
      "guestinfo.dns.server.0"                    = var.cluster_config.shared.dns_server1
      "guestinfo.dns.server.1"                    = var.cluster_config.shared.dns_server2
    }
  }
  depends_on = [
    volterra_token.node-2,
    volterra_securemesh_site_v2.node-1
    ]

  lifecycle {
    ignore_changes = [
      vapp[0].properties["guestinfo.hostname"],
      vapp[0].properties["guestinfo.ves.adminpassword"]
    ]
  }
}

resource "vsphere_virtual_machine" "node3" {
  name                 = format("%s-%s", var.vsphere_config.virtual_machine_prefix, var.cluster_config.node3.hostname)
  datacenter_id        = data.vsphere_datacenter.datacenter.id
  datastore_id         = data.vsphere_datastore.datastore.id
  host_system_id       = data.vsphere_host.host1.id
  resource_pool_id     = data.vsphere_compute_cluster.cluster.resource_pool_id
  num_cpus             = var.num_cpus
  num_cores_per_socket = 1
  memory               = var.memory
  guest_id             = data.vsphere_ovf_vm_template.ovf-template.guest_id
  scsi_type            = data.vsphere_ovf_vm_template.ovf-template.scsi_type
  nested_hv_enabled    = data.vsphere_ovf_vm_template.ovf-template.nested_hv_enabled
  folder               = trimprefix(data.vsphere_folder.folder.path, "/${data.vsphere_datacenter.datacenter.name}/vm")

  network_interface {
    network_id  = data.vsphere_network.outside.id
    ovf_mapping = "OUTSIDE"
  }

  network_interface {
    network_id  = data.vsphere_network.inside.id
    ovf_mapping = "INSIDE"
  }

  disk {
    label          = "disk0"
    size           = 80
    unit_number    = 0
    io_share_count = 1000

  }

  wait_for_guest_net_timeout = 0
  wait_for_guest_ip_timeout  = 0

  ovf_deploy {
    allow_unverified_ssl_cert = true
    remote_ovf_url            = data.vsphere_ovf_vm_template.ovf-template.remote_ovf_url
    disk_provisioning         = data.vsphere_ovf_vm_template.ovf-template.disk_provisioning
  }

  vapp {
    properties = {
      "guestinfo.hostname"  = var.cluster_config.node1.hostname
      "guestinfo.ves.token" = volterra_token.node-3.id
      "guestinfo.ves.adminpassword" : var.cluster_config.shared.admin_password
      "guestinfo.interface.0.dhcp"                = "no"
      "guestinfo.interface.0.ip.0.address"        = var.cluster_config.node1.addresses.outside
      "guestinfo.interface.0.route.0.gateway"     = var.cluster_config.node1.route.gateway
      "guestinfo.interface.0.route.0.destination" = var.cluster_config.node1.route.destination
      "guestinfo.dns.server.0"                    = var.cluster_config.shared.dns_server1
      "guestinfo.dns.server.1"                    = var.cluster_config.shared.dns_server2
    }
  }
  depends_on = [
    volterra_token.node-3,
    volterra_securemesh_site_v2.node-1
    ]

  lifecycle {
    ignore_changes = [
      vapp[0].properties["guestinfo.hostname"],
      vapp[0].properties["guestinfo.ves.adminpassword"]
    ]
  }
}