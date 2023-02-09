// Enterprise Application
resource "azuread_application" "demopak-ea" {
    display_name = var.enterprise_application_name
}

// Service Principal
resource "azuread_service_principal" "demopak-sp" {
    application_id = azuread_application.demopak-ea.application_id
}

resource "azuread_service_principal_password" "demopak-sp-secret" {
    service_principal_id = azuread_service_principal.demopak-sp.id
}

output "service_principal_password" {
    value = azuread_service_principal_password.demopak-sp-secret.value
    sensitive = true
}

// Azure AKS
resource "azurerm_kubernetes_cluster" "demopak-aks-cluster" {
    name = var.aks_cluster_name
    location = var.location
    resource_group_name = azurerm_resource_group.demopak-rg.name
    dns_prefix = "demopak-dns"
    
    default_node_pool {
        name = "default"
        node_count = 1
        vm_size = "Standard_B1s" // It is not possible to create nodes with this configuration
    }

    service_principal {
        client_id = azuread_service_principal.demopak-sp.application_id
        client_secret = azuread_service_principal_password.demopak-sp-secret.value
    }
}

output "client_certificate" {
  value = azurerm_kubernetes_cluster.demopak-aks-cluster.kube_config.0.client_certificate
}

output "kube_config" {
  value     = azurerm_kubernetes_cluster.demopak-aks-cluster.kube_config_raw
  sensitive = true
}