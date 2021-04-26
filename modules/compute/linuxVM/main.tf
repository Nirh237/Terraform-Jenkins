
#Create virtual machines - Private
resource "azurerm_virtual_machine" "privateVM" {
 name                  = var.name
 location              = var.location
 availability_set_id   = var.availability_set_id
 resource_group_name   = var.resource_group_name
 network_interface_ids = var.network_interface_ids
 vm_size               = "Standard_DS1_v2" 



 storage_image_reference {
   publisher  = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
 }

 storage_os_disk {
   name              = var.computer_name
   caching           = "ReadWrite"
   create_option     = "FromImage"
   managed_disk_type = "Standard_LRS"
 }

  os_profile {
   computer_name  = var.computer_name
   admin_username = var.admin_username
   admin_password = var.admin_password
 }

  os_profile_linux_config {
   disable_password_authentication = false
 }
}

