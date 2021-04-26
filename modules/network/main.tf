
#Create resource group
resource "azurerm_resource_group" "rg" {
  name     = var.resource_group_name
  location = var.location 
}

#Create virtual network
resource "azurerm_virtual_network" "vnet" {
  name                = "vnet_Proj5"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  address_space       = var.vnet
}

#Create subnets - Public and Private
  resource "azurerm_subnet" "publicSubnet" {
  name                 = "public-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.0.0/24"]
  }


  resource "azurerm_subnet" "privateSubnet" {
  name                 = "private-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
  }



#Create public ip - Public Load Balancer IP
  resource "azurerm_public_ip" "publicIPLB" {
 name                         = "publicIPLB_proj5"
 location                     = var.location
 resource_group_name          = azurerm_resource_group.rg.name
 allocation_method            = "Static"
}

#Create public ip - Public IP
  resource "azurerm_public_ip" "publicIP" {
 name                         = "publicIP_proj5"
 location                     = var.location
 resource_group_name          = azurerm_resource_group.rg.name
 allocation_method            = "Static"
}

/*
#Create Load Balancer - Public Load Balancer
resource "azurerm_lb" "publicLB" {
 name                = "loadBalancer"
 location            = var.location
 resource_group_name = azurerm_resource_group.rg.name

frontend_ip_configuration {
   name                 = "publicIPAddress"
   public_ip_address_id =  azurerm_public_ip.publicIPLB.id
 }
}


resource "azurerm_lb_rule" "publicLBRule" {
  resource_group_name            = azurerm_resource_group.rg.name
  loadbalancer_id                = azurerm_lb.publicLB.id
  name                           = "PublicLBRule"
  protocol                       = "Tcp"
  frontend_port                  = 8080
  backend_port                   = 8080
  frontend_ip_configuration_name = "publicIPAddress"
  backend_address_pool_id        = azurerm_lb_backend_address_pool.backendLBPool.id
  probe_id                       = azurerm_lb_probe.HPPublicLB.id
}

resource "azurerm_lb_probe" "HPPublicLB" {
  resource_group_name = azurerm_resource_group.rg.name
  loadbalancer_id     = azurerm_lb.publicLB.id
  name                = "tcp-running-probe"
  port                = 8080
}

resource "azurerm_lb_backend_address_pool" "backendLBPool" {
 resource_group_name = azurerm_resource_group.rg.name
 loadbalancer_id     = azurerm_lb.publicLB.id
 name                = "BackEndAddressPool"
}

#Create availability set - Public and Private
resource "azurerm_availability_set" "avsetPublic" {
 name                         = "avsetpublic"
 location                     = var.location
 resource_group_name          = azurerm_resource_group.rg.name
 platform_fault_domain_count  = 3
 platform_update_domain_count = 3
 managed                      = true
}

resource "azurerm_availability_set" "avsetPrivate" {
 name                         = "avsetprivate"
 location                     = var.location
 resource_group_name          = azurerm_resource_group.rg.name
 platform_fault_domain_count  = 1
 platform_update_domain_count = 1
 managed                      = true
}
*/





#Create nic - Newtwork Interface Card Public
resource "azurerm_network_interface" "nicPublic" {
 count                        = 3
 name                         = "public-vm${count.index}"
 location                     = var.location
 resource_group_name          = azurerm_resource_group.rg.name

 ip_configuration {
   name                          = "nicConfigurationPublic"
   subnet_id                     = azurerm_subnet.publicSubnet.id
   private_ip_address_allocation = "dynamic"
 }
}


#Create nic - Newtwork Interface Card Private
resource "azurerm_network_interface" "nicPrivate" {
 name                         = "private-vm"
 location                     = var.location
 resource_group_name          = azurerm_resource_group.rg.name

 ip_configuration {
   name                          = "nicConfigurationPrivate"
   subnet_id                     = azurerm_subnet.privateSubnet.id
   private_ip_address_allocation = "dynamic"
 }
}



/*
#network_interface_backend_address_pool_association
resource "azurerm_network_interface_backend_address_pool_association" "example" {
  count                   = 3
  network_interface_id    = "${element(azurerm_network_interface.nicPublic.*.id, count.index)}"
  ip_configuration_name   = "nicConfigurationPublic"
  backend_address_pool_id = azurerm_lb_backend_address_pool.backendLBPool.id
}
*/


resource "azurerm_managed_disk" "azureManagedDisk" {
 count                = 3
 name                 = "datadisk_existing_${count.index}_proj5"
 location              = var.location
 resource_group_name  =  azurerm_resource_group.rg.name
 storage_account_type = "Standard_LRS"
 create_option        = "Empty"
 disk_size_gb         = "1023"
}


#Create network security groups - Public
  resource "azurerm_network_security_group" "publicNsg" {
  name                = "public-nsg_proj5"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  
  security_rule {
    name                       = "port8080in"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "8080"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
    }

      security_rule {
    name                       = "port8080out"
    priority                   = 100
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "8080"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
    }

     security_rule {
     name                       = "SSH"
     priority                   = 110
     direction                  = "Inbound"
     access                     = "Allow"
     protocol                   = "Tcp"
     source_port_range          = "*"
     destination_port_range     = "22"
     source_address_prefix      = "*"
     destination_address_prefix = "*"
    }

      security_rule {
     name                       = "SSH"
     priority                   = 110
     direction                  = "Outbound"
     access                     = "Allow"
     protocol                   = "Tcp"
     source_port_range          = "*"
     destination_port_range     = "22"
     source_address_prefix      = "*"
     destination_address_prefix = "*"
    }
/*
      security_rule {
     name                       = "rdp-in"
      priority                   = 110
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range    = "3389"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    }

      security_rule {
      name                       = "rdp-out"
      priority                   = 110
      direction                  = "Outbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range    = "3389"
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    }
    */
  }

#subnet network security group association
  resource "azurerm_subnet_network_security_group_association" "publicNsgAssociation" {
  subnet_id                 = azurerm_subnet.publicSubnet.id
  network_security_group_id = azurerm_network_security_group.publicNsg.id
}

# Create network security groups - Private
 resource "azurerm_network_security_group" "privateNsg" {
  name                = "private-nsg_proj5"
  location            = var.location
  resource_group_name = azurerm_resource_group.rg.name
  
  security_rule {
     name                       = "SSH"
     priority                   = 300
     direction                  = "Inbound"
     access                     = "Allow"
     protocol                   = "Tcp"
     source_port_range          = "*"
     destination_port_range     = "22"
     source_address_prefix      = "*"
     destination_address_prefix = "*"
    }

      security_rule {

     name                       = "postgrsqlPort"
     priority                   = 310
     direction                  = "Inbound"
     access                     = "Allow"
     protocol                   = "Tcp"
     source_port_range          = "*"
     destination_port_range     = "5432"
     source_address_prefix      = "*"
     destination_address_prefix = "*"
    }
  }


  resource "azurerm_subnet_network_security_group_association" "privateNsgAssociation" {
  subnet_id                 = azurerm_subnet.privateSubnet.id
  network_security_group_id = azurerm_network_security_group.privateNsg.id
}

