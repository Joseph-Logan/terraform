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
