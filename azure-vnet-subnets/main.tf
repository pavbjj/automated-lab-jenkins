provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
  client_id       = var.client_id
  client_secret   = var.client_secret
  tenant_id       = var.tenant_id
}

resource "azurerm_resource_group" "main" {
  name     = "p-kuligowski-jenkins-vnet-rg"
  location = "eastus"
}

resource "azurerm_virtual_network" "main" {
  name                = "p-kuligowski-jenkins-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
}

resource "azurerm_subnet" "outside" {
  name                 = "outside-subnet"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.1.0/24"]
  delegation {
    name = "natdelegation"
    service_delegation {
      name = "Microsoft.Network/natGateways"
      actions = ["Microsoft.Network/natGateways/*"]
    }
  }
}

resource "azurerm_subnet" "inside" {
  name                 = "inside-subnet"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_public_ip" "nat" {
  name                = "nat-gateway-public-ip"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  allocation_method   = "Static"
  sku                 = "Standard"
}

resource "azurerm_nat_gateway" "nat" {
  name                = "p-kuligowski-nat-gateway"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  sku_name            = "Standard"

  public_ip_address_id = azurerm_public_ip.nat.id
}

resource "azurerm_subnet_nat_gateway_association" "outside" {
  subnet_id      = azurerm_subnet.outside.id
  nat_gateway_id = azurerm_nat_gateway.nat.id
}

resource "azurerm_network_security_group" "nsg" {
  name                = "p-kuligowski-nsg-vnet-restrict"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  security_rule {
    name                       = "Allow-Inbound-From-VNet"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
  }

  security_rule {
    name                       = "Allow-All-Outbound"
    priority                   = 110
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
  }
}

resource "azurerm_subnet_network_security_group_association" "outside" {
  subnet_id                 = azurerm_subnet.outside.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}

resource "azurerm_subnet_network_security_group_association" "inside" {
  subnet_id                 = azurerm_subnet.inside.id
  network_security_group_id = azurerm_network_security_group.nsg.id
}
