# Configure the Azure provider
terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = ">= 2.26"
    }
  }
}

provider "azurerm" {
  features {}
}


module "network" {
   source = "./modules/network"

   resource_group_name = var.resource_group_name
   location            = var.location
   vnet                = var.vnet


}
/*
module "compute" {
   source = "./modules/compute/winsowsVM"
   resource_group_name           = module.network.resource_group_name
   location                      = module.network.location
   vnet                          = [module.network.vnet]
   admin_username                = var.admin_username
   admin_password                = var.admin_password
   vm_size                       = var.vm_size
   network_interface_ids         = [module.network.network_interface_ids_public_windows]
   availability_set_id           = module.network.availability_set_public

}
*/
module "compute" {
   source = "./modules/compute/linuxVM"

   name                          = var.linuxVMName[0]
   resource_group_name           = module.network.resource_group_name
   location                      = module.network.location
   vnet                          = [module.network.vnet]
   admin_username                = var.admin_username
   admin_password                = var.admin_password
   vm_size                       = var.vm_size
   network_interface_ids         = [module.network.network_interface_ids_public_linuxMaster]
   availability_set_id           = module.network.availability_set_public
   computer_name                 = var.linuxVMName[0]
}

module "compute1" {
   source = "./modules/compute/linuxVM"

   name                          = var.linuxVMName[1]
   resource_group_name           = module.network.resource_group_name
   location                      = module.network.location
   vnet                          = [module.network.vnet]
   admin_username                = var.admin_username
   admin_password                = var.admin_password
   vm_size                       = var.vm_size
   network_interface_ids         = [module.network.network_interface_ids_public_linuxBuild]
   availability_set_id           = module.network.availability_set_public
   computer_name                 = var.linuxVMName[1]
}

module "compute2" {
   source = "./modules/compute/linuxVM"

   name                          = var.linuxVMName[2]
   resource_group_name           = module.network.resource_group_name
   location                      = module.network.location
   vnet                          = [module.network.vnet]
   admin_username                = var.admin_username
   admin_password                = var.admin_password
   vm_size                       = var.vm_size
   network_interface_ids         = [module.network.network_interface_ids_public_linuxDeploy]
   availability_set_id           = module.network.availability_set_public
   computer_name                 = var.linuxVMName[2]
}

module "compute3" {
   source = "./modules/compute/linuxVM"

   name                          = var.linuxVMName[3]
   resource_group_name           = module.network.resource_group_name
   location                      = module.network.location
   vnet                          = [module.network.vnet]
   admin_username                = var.admin_username
   admin_password                = var.admin_password
   vm_size                       = var.vm_size
   network_interface_ids         = [module.network.network_interface_ids_private]
   availability_set_id           = module.network.availability_set_private
   computer_name                 = var.linuxVMName[3]
 

}