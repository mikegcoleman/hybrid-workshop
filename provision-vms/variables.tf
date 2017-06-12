# Settings

variable "resource_group" {
  description = "Name of the resource group to use for VMs"
  type = "string"
  default = "mike-pa"
}

variable "storage_account" {
  description = "Name of the storage account to use for VMs"
  type = "string"
  default = "mikepa"
}

variable "dns_prefix" {
  description = "DNS prefix for VM public addreses"
  type = "string"
  default = "pa"
}

variable "region" {
  description = "Azure region to use"
  type = "string"
  default = "westus2"
}

variable "win_image_vhd_uri" {
  description = "URI of the windows VHD to use as the VM image"
  type = "string"
  default = "https://mikergdisks645.blob.core.windows.net/vhds/win2016-17-05-osDisk.2eb0a541-44f5-44a4-8416-0280d4976722.vhd?st=2017-05-25T00%3A44%3A00Z&se=2018-05-26T00%3A44%3A00Z&sp=rl&sv=2016-05-31&sr=b&sig=wSbPKamsKmlTuqPVZPEt44Y8MIGR5taf%2BykNgwmt%2B70%3D"
}

variable "lin_image_vhd_uri" {
  description = "URI of the linux VHD to use as the VM image"
  type = "string"
  default = "https://mikergdisks645.blob.core.windows.net/vhds/linux-base20170523165353.vhd?st=2017-05-24T06%3A06%3A00Z&se=2018-05-25T06%3A06%3A00Z&sp=rl&sv=2016-05-31&sr=b&sig=9hLOky1FufB0u60pojAqUgeej7iZRrHxloZ%2Fi7FSs38%3D"
}

variable "win_vm_count" {
  description = "Number of VMs to create"
  type = "string"
  default = "100"
}

variable "lin_vm_count" {
  description = "Number of VMs to create"
  type = "string"
  default = "100"
}

variable "vm_size" {
  description = "VM size to create"
  type = "string"
  default = "Standard_DS1_v2"
}

variable "azure_dns_suffix" {
    description = "Azure DNS suffix for public addresses"
    default = "cloudapp.azure.com"
}
