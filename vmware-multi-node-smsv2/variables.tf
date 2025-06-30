#variable volterra_config {#
#
#  type = object({
#    url = string
#    api_cert     = string
#    api_key      = string
#  })
#
#}

variable "url" {}
variable "api_cert" {}
variable "api_key" {}

variable "vsphere_config" {

  type = object({
    datacenter             = string
    compute_cluster        = string
    datastore              = string
    network_outside        = string
    network_inside         = string
    folder                 = string
    hosts                  = list(string)
    virtual_machine_prefix = string
  })

  validation {
    condition     = length(var.vsphere_config.hosts) == 3
    error_message = "Only three hosts are allowed"
  }

}

variable "cluster_config" {

  type = object({

    shared = object({
      ova_url = string
      admin_password = string
      dns_server1    = string
      dns_server2    = string
    })

    node1 = object({
      hostname = string
      addresses = object({
        outside = string
      })
      route = object({
        destination = string
        gateway     = string
      })
    })

    node2 = object({
      hostname = string
      addresses = object({
        outside = string
      })
      route = object({
        destination = string
        gateway = string
      })
    })

    node3 = object({
      hostname = string
      addresses = object({
        outside = string
      })
      route = object({
        destination = string
        gateway = string
      })
    })

  })
}

variable "prefix" {
  type = string
}

variable "description" {
  type = string
}

variable "memory" {
  type = number
}

variable "num_cpus" {
  type = number
}
