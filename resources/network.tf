// VNet
resource "azurerm_virtual_network" "demopak-vnet" {
    name = var.virtual_network_name
    location = var.location
    resource_group_name = azurerm_resource_group.demopak-rg.name
    address_space = ["10.0.0.0/16"]
}

// Subnet 1
resource "azurerm_subnet" "demopak-subnet-1" {
    name = "demopak-subnet-1"
    resource_group_name = azurerm_resource_group.demopak-rg.name
    virtual_network_name = azurerm_virtual_network.demopak-vnet.name
    address_prefixes = ["10.0.0.0/24"]
}

// Subnet 2
resource "azurerm_subnet" "demopak-subnet-2" {
    name = "demopak-subnet-2"
    resource_group_name = azurerm_resource_group.demopak-rg.name
    virtual_network_name = azurerm_virtual_network.demopak-vnet.name
    address_prefixes = ["10.0.2.0/24"]
}

// NSG - Network Security Group
resource "azurerm_network_security_group" "demopak-nsg" {
    name                = "demopak-nsg"
    location            = var.location
    resource_group_name = azurerm_resource_group.demopak-rg.name

    // Port 80 (HTTP)
    security_rule {
        name                       = "HTTP"
        priority                   = 1001
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "80"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }

    // Port 22 (SSH)
    security_rule {
        name                       = "SSH"
        priority                   = 1002
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "Tcp"
        source_port_range          = "*"
        destination_port_range     = "22"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }
}