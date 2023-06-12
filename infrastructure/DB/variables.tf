variable "sql_db_name" {
  type        = string
  description = "The name of the SQL Database."
  default     = "octopus"
}

variable "admin_username" {
  type        = string
  description = "The administrator username of the SQL logical server."
  default     = "octo"
}

variable "admin_password" {
  type        = string
  description = "The administrator password of the SQL logical server."
  sensitive   = true
  default     = null
}

variable "mssql_version" {
  type        = string
  default     = "12.0"
  description = "Define the database configuration version"
}

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



