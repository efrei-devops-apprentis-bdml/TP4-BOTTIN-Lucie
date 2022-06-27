resource   "azurerm_public_ip"   "myvmpublicip"   { 
   name   =   "devops-20180304-IP" 
   location   =   "francecentral" 
   resource_group_name   =   data.azurerm_resource_group.tp4.name
   allocation_method   =   "Dynamic" 
   sku   =   "Basic" 
 } 

 resource   "azurerm_network_interface"   "myvm"   { 
   name   =   "devops-20180304-interface" 
   location   =   "francecentral" 
   resource_group_name   =   data.azurerm_resource_group.tp4.name

   ip_configuration   { 
     name   =   "ipconfig" 
     subnet_id   =   data.azurerm_subnet.sub_tp4.id 
     private_ip_address_allocation   =   "Dynamic" 
     public_ip_address_id   =   azurerm_public_ip.myvmpublicip.id 
   } 
 } 

 resource   "azurerm_linux_virtual_machine"   "vm"   { 
   name                    =   "devops-20180304"   
   location                =   "francecentral" 
   resource_group_name     =   data.azurerm_resource_group.tp4.name
   network_interface_ids   =   [ azurerm_network_interface.myvm.id ] 
   size                    =   "Standard_D2s_v3" 
   admin_username          =   "devops" 
   admin_password          =   "StrongPassword1" 
   disable_password_authentication = false


   source_image_reference   { 
     publisher   =   "Canonical" 
     offer       =   "UbuntuServer" 
     sku         =   "16.04-LTS" 
     version     =   "latest" 
   } 

   os_disk   { 
     storage_account_type   =   "Standard_LRS" 
     caching             =   "ReadWrite" 
   } 
 } 