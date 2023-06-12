variable "resource_group_location" {
  type        = string
  default     = "eastus"
  description = "Location of the resource group."
}

variable "resource_vm_group_name" {
  type        = string
  default     = "virtual-machines-group"
  description = "Resource group name of virtual machine created"
}

variable "init_vm_script" {
  type    = string
  default = "./scripts/test.sh"
}

variable "vnet_name" {
  type        = string
  default     = "ci-cd-vnet"
  description = "Name of virtual network"
}

variable "subnet_name" {
  type        = string
  default     = "ci-cd-subnet"
  description = "Name of subnet"
}

variable "sql_server_domain_name" {
  type        = string
  default     = "sql-octopus-buzzard.database.windows.net"
  description = "Domain name of sql server created"
}

variable "sql_db_name" {
  type        = string
  default     = "octopus"
  description = "Name of database"
}

variable "admin_username" {
  type        = string
  default     = "octo"
  description = "Admin user name of database"
}

variable "admin_password" {
  type        = string
  default     = "i)fg:w1p<{[Qr<VcR_1K"
  description = "Admin password generated DB module"
}
