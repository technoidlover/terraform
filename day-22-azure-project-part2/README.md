````markdown
# Day 22: Azure Resources

Deploy virtual machines, storage, and networking on Azure.

## Key Topics

1. Virtual Machines
2. Storage Accounts
3. Networks and Subnets
4. Network Interfaces
5. Databases

## Virtual Machine

```hcl
resource "azurerm_virtual_machine" "main" {
  name                  = "vm-main"
  location              = azurerm_resource_group.main.location
  resource_group_name   = azurerm_resource_group.main.name
  vm_size               = "Standard_B1s"

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  storage_os_disk {
    name          = "os-disk"
    caching       = "ReadWrite"
    create_option = "FromImage"
  }

  os_profile {
    computer_name  = "vm-main"
    admin_username = "azureuser"
  }

  os_profile_linux_config {
    disable_password_authentication = true

    ssh_keys {
      path     = "/home/azureuser/.ssh/authorized_keys"
      key_data = file("~/.ssh/id_rsa.pub")
    }
  }

  network_interface_ids = [
    azurerm_network_interface.main.id
  ]
}
```

## Storage Account

```hcl
resource "azurerm_storage_account" "main" {
  name                     = "stg${substr(md5(azurerm_resource_group.main.id), 0, 8)}"
  resource_group_name      = azurerm_resource_group.main.name
  location                 = azurerm_resource_group.main.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  https_traffic_only_enabled = true

  tags = {
    Environment = var.environment
  }
}

resource "azurerm_storage_container" "data" {
  name                  = "data"
  storage_account_name  = azurerm_storage_account.main.name
  container_access_type = "private"
}
```

## Network

```hcl
resource "azurerm_virtual_network" "main" {
  name                = "vnet-main"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
}

resource "azurerm_subnet" "main" {
  name                 = "subnet-main"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_network_interface" "main" {
  name                = "nic-main"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  ip_configuration {
    name                          = "testconfiguration1"
    subnet_id                     = azurerm_subnet.main.id
    private_ip_address_allocation = "Dynamic"
  }
}
```

## Lab: Complete Azure Stack

Deploy VNet, VMs, and Storage Account.

---

Estimated Time: 3-4 hours

````
