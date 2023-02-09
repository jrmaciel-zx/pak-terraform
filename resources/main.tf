terraform {
  required_version = ">= 0.12"
}

provider "azurerm" {
    features {}
}

// Resource Group
resource "azurerm_resource_group" "demopak-rg" {
    name = var.resource_group_name
    location = var.location
    tags = {
        env = "demo-env"
    }
}