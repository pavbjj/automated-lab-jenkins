terraform {
  backend "azurerm" {
    resource_group_name  = "p-kuligowski-rg"
    storage_account_name = "pkuligowskixc"
    container_name       = "f5xc"
    key                  = "jenkins-multi-node-new-vnet.tfstate"
  }
}
