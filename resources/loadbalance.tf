resource "azurerm_virtual_machine_scale_set" "demopak-ss" {
  name = var.vm_scale_set_name
  location = var.location
  resource_group_name = azurerm_resource_group.demo-pak.name
  upgrade_policy_mode = "Manual"
  zones = var.zones

  sku {
    name     = "Standard_B2s"
    tier     = "Standard"
    capacity = 2
  }

  storage_profile_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  storage_profile_os_disk {
    name              = ""
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  storage_profile_data_disk {
    lun           = 0
    caching       = "ReadWrite"
    create_option = "Empty"
    disk_size_gb  = 10
  }

  os_profile {
    computer_name_prefix = "demopak"
    admin_username       = "demopak"
  }

  extension {
    name                 = "InstallCustomScript"
    publisher            = "Microsoft.Azure.Extensions"
    type                 = "CustomScript"
    type_handler_version = "2.0"
    settings             = <<SETTINGS
        {
          "fileUris": ["https://raw.githubusercontent.com/in4it/terraform-azure-course/master/application-gateway/install_nginx.sh"], 
          "commandToExecute": "./install_nginx.sh"
        }
      SETTINGS
  }

  os_profile_linux_config {
    disable_password_authentication = true

    ssh_keys {
      key_data = file("mykey.pub")
      path     = "/home/demo/.ssh/authorized_keys"
    }
  }

  network_profile {
    name                                     = "networkprofile"
    primary                                  = true
    network_security_group_id                = azurerm_network_security_group.demo-instance.id

    ip_configuration {
      name                                   = "IPConfiguration"
      primary                                = true
      subnet_id                              = azurerm_subnet.demo-subnet-2.id
      application_gateway_backend_address_pool_ids = [azurerm_application_gateway.app-gateway.backend_address_pool.0.id]
    }
  }
}