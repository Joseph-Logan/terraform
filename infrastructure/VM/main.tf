# Create public IPs
resource "azurerm_public_ip" "octopus_public_ip" {
  name                = "vm-octopus-ip"
  location            = var.resource_group_location
  resource_group_name = var.resource_vm_group_name
  allocation_method   = "Dynamic"
}

# Create Network Security Group and rule
resource "azurerm_network_security_group" "vm_nsg" {
  name                = "VM-Octopus-nsg"
  location            = var.resource_group_location
  resource_group_name = var.resource_vm_group_name

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
    name                       = "HTTP"
    priority                   = 320
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

data "azurerm_subnet" "local_virtual_network_subnet" {
  name                 = var.subnet_name
  virtual_network_name = var.vnet_name
  resource_group_name  = var.resource_vm_group_name
}

# Create network interface
resource "azurerm_network_interface" "vn_nic" {
  name                = "vm-nic"
  location            = var.resource_group_location
  resource_group_name = var.resource_vm_group_name

  ip_configuration {
    name                          = "vm_nic_configuration"
    subnet_id                     = data.azurerm_subnet.local_virtual_network_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.octopus_public_ip.id
  }
}

# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "nic_sga" {
  network_interface_id      = azurerm_network_interface.vn_nic.id
  network_security_group_id = azurerm_network_security_group.vm_nsg.id
}

# Generate random text for a unique storage account name
resource "random_id" "random_id" {
  keepers = {
    # Generate a new ID only when a new resource group is defined
    resource_group = var.resource_vm_group_name
  }

  byte_length = 8
}

# Create storage account for boot diagnostics
resource "azurerm_storage_account" "storage_account" {
  name                     = "diag${random_id.random_id.hex}"
  location                 = var.resource_group_location
  resource_group_name      = var.resource_vm_group_name
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

# Get ssh key reference name
data "azurerm_ssh_public_key" "ssh_key" {
  name                = "ci-cd"
  resource_group_name = "virtual-machines"
}

# Create virtual machine
resource "azurerm_linux_virtual_machine" "vm" {
  name                  = "octopus-vm"
  location              = var.resource_group_location
  resource_group_name   = var.resource_vm_group_name
  network_interface_ids = [azurerm_network_interface.vn_nic.id]
  size                  = "Standard_B1s"

  custom_data = base64encode(templatefile("./scripts/init-vm.tpl", {
    sql_server_domain_name = var.sql_server_domain_name
    sql_db_name            = var.sql_db_name
    admin_username         = var.admin_username
    admin_password         = var.admin_password
  }))

  os_disk {
    name                 = "VMOsDisk"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts-gen2"
    version   = "latest"
  }

  computer_name                   = "octopus-vm"
  admin_username                  = "azureuser"
  disable_password_authentication = true

  admin_ssh_key {
    username   = "azureuser"
    public_key = data.azurerm_ssh_public_key.ssh_key.public_key
  }

  boot_diagnostics {
    storage_account_uri = azurerm_storage_account.storage_account.primary_blob_endpoint
  }
}