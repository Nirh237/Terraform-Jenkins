
#Create Windows Jenkins Master virtual machines - Public 
/*
resource "azurerm_virtual_machine" "publicVM" {
 name                  = "VM-JenkMaster"
 location              = var.location
 availability_set_id   = var.availability_set_id
 resource_group_name   = var.resource_group_name
 network_interface_ids = var.network_interface_ids
 vm_size               = var.vm_size 

 storage_image_reference {
   publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
 }

 storage_os_disk {
   name              = "myWJenkMasterdisk"
   caching           = "ReadWrite"
   create_option     = "FromImage"
   managed_disk_type = "Standard_LRS"
 }

  os_profile {
   computer_name  = "VM-JenkMaster"
   admin_username = var.admin_username
   admin_password = var.admin_password
 }

  os_profile_windows_config {
   provision_vm_agent = false
 }
}
*/

/*
#Create availability set - Public and Private
resource "azurerm_availability_set" "avsetPublic" {
 name                         = "avsetpublic"
 location                     = var.location
 resource_group_name          = var.resource_group_name
 platform_fault_domain_count  = 1
 platform_update_domain_count = 1
 managed                      = true
}

resource "azurerm_availability_set" "avsetPrivate" {
 name                         = "avsetPrivate"
 location                     = var.location
 resource_group_name          = var.resource_group_name
 platform_fault_domain_count  = 1
 platform_update_domain_count = 1
 managed                      = true
}
*/

