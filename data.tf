data "azurerm_resource_group" "tp4" {
    name = "devops-TP2"
}

data "azurerm_virtual_network" "net_tp4" {
    name = "example-network"
    resource_group_name = data.azurerm_resource_group.tp4.name
} 

data "azurerm_subnet" "sub_tp4" {
    name = "internal"
    resource_group_name   =    data.azurerm_resource_group.tp4.name 
    virtual_network_name   =   data.azurerm_virtual_network.net_tp4.name 
}