volterra_config = {
    api_p12_file = "./p12.p12"
    url = "https://f5-consult.console.ves.volterra.io/api"
}

prefix = "p-kuligowski"
description = "Vmware TF"
memory = 16384
num_cpus = 4

vsphere_config = {
    datacenter = "waw-gslab-dc"
    compute_cluster = "Cluster2-v7.0-Intel"
    datastore = "RunningVMs-1"
    network_outside = "Public Access"
    network_inside = "pkuligowski"
    folder = "/waw-gslab-dc/vm/p/pkuligowski/"
    hosts = [
        "esx-r2-s33.waw.gs.lab",
        "esx-r2-s33.waw.gs.lab",
        "esx-r2-s33.waw.gs.lab"
    ]
    virtual_machine_prefix = "f5xc"
}

cluster_config = {

    shared = {
        ova_url = "https://vesio.blob.core.windows.net/releases/rhel/9/x86_64/images/vmware/securemeshV2/f5xc-ce-9.2024.44-20241229163026.ova"
        admin_password = "Volterra123"
        dns_server1 = "8.8.8.8"
        dns_server2 = "1.1.1.1"

    }

    node1 = {
        hostname = "node-0"
        addresses = {
            outside = "10.171.176.140/16"
  
        }
        route = {
            destination = "0.0.0.0/0"
            gateway = "10.171.255.254"
        }
    }
}

