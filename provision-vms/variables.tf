# Settings

variable "resource_group" {
  description = "Name of the resource group to use for VMs"
  type = "string"
# add the name of the resource group you want created (cannot exist)
  default = ""
}

variable "storage_account" {
  description = "Name of the storage account to use for VMs"
  type = "string"
# add the name of the storage account you want created (cannot exist)
  default = ""
}

variable "dns_prefix" {
  description = "DNS prefix for VM public addreses"
  type = "string"
# This string is used as the first part of dns name eg: pdx-lin-01 or pdx-win-01
  default = ""
}

variable "region" {
  description = "Azure region to use"
  type = "string"
# Supply a default region (e.g. westus2)
  default = ""
}

variable "win_image_vhd_uri" {
  description = "URI of the windows VHD to use as the VM image"
  type = "string"
# you need to supply a link to a valid Windows Azure image
  default = ""
}

variable "lin_image_vhd_uri" {
  description = "URI of the linux VHD to use as the VM image"
  type = "string"
# you need to supply a link to a valid Linux Azure image
  default = ""
}

variable "win_vm_count" {
  description = "Number of VMs to create"
  type = "string"
# specify the number of Windows VMs to create
  default = ""
}

variable "lin_vm_count" {
  description = "Number of VMs to create"
  type = "string"
# specify the number of Linux VMs to create
  default = ""
}

variable "vm_size" {
  description = "VM size to create"
  type = "string"
# specify the VM size to create (e.g. Standard_DS1_v2)
  default = ""
}

variable "azure_dns_suffix" {
    description = "Azure DNS suffix for public addresses"
    default = "cloudapp.azure.com"
}
