
variable "admin_username" {
description = "admin_username"
type = string
}

variable "admin_password" {
description = "admin_password"
type = string
}

variable "network_interface_ids" {
description = "network_interface_ids_public"
type = list(string)
}

variable "resource_group_name" {
description = "resource group name"
type = string
}

variable "location" {
    description = "location"
    type = string
}

variable "vnet" {
    description = "Vnet CIDR"
    type = list(string)
    default = ["10.0.0.0/16"]
    
}

variable "vm_size" {
description = "vm size"
type = string
}

variable "availability_set_id" {
 description = "availability_set_id" 
 type = string  
}