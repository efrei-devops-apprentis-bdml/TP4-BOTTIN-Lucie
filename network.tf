resource   "azurerm_public_ip"   "myvmpublicip"   { 
   name   =   "devops-20180304-IP" 
   location   =   var.location
   resource_group_name   =   data.azurerm_resource_group.tp4.name
   allocation_method   =   "Dynamic" 
   sku   =   "Basic" 
 } 

 resource   "azurerm_network_interface"   "myvm"   { 
   name   =   "devops-20180304-interface" 
   location   =   var.location
   resource_group_name   =   data.azurerm_resource_group.tp4.name

   ip_configuration   { 
     name   =   "ipconfig" 
     subnet_id   =   data.azurerm_subnet.sub_tp4.id 
     private_ip_address_allocation   =   "Dynamic" 
     public_ip_address_id   =   azurerm_public_ip.myvmpublicip.id 
   } 
 } 

resource "azurerm_network_security_group" "security" {
  name                = "20180304-Security"
  location            = var.location
  resource_group_name = data.azurerm_resource_group.tp4.name

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_interface_security_group_association" "example" {
  network_interface_id      = azurerm_network_interface.myvm.id
  network_security_group_id = azurerm_network_security_group.security.id
}

resource "tls_private_key" "example_ssh" {
  algorithm = "RSA"
  rsa_bits  = 4096
}


 resource   "azurerm_linux_virtual_machine"   "vm"   { 
   name                    =   "devops-20180304"   
   location                =   var.location
   resource_group_name     =   data.azurerm_resource_group.tp4.name
   network_interface_ids   =   [ azurerm_network_interface.myvm.id ] 
   size                    =   "Standard_D2s_v3"

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

    computer_name                   = "myvm"
    admin_username                  = "devops"
    disable_password_authentication = true

   admin_ssh_key {
    username   = "devops"
    public_key = tls_private_key.example_ssh.public_key_openssh
  }
 } 