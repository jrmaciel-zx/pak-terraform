variable location {
    type = string
    default = "brazilsouth"
}

variable resource_group_name {
    type = string
    default = "demopak-resource-group"
}

variable virtual_network_name {
    type = string
    default = "demopak-vnet"
}

variable vm_scale_set_name {
    type = string
    default = "demopak-vm-loadbalance"
}

variable zones {
  type    = list(string)
  default = []
}