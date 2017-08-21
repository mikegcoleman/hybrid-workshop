# Settings

variable "resource_group" {
  description = "Name of the resource group to use for VMs"
  type = "string"
  default = "wrkshp"
}

variable "storage_account" {
  description = "Name of the storage account to use for VMs"
  type = "string"
  default ="wrkshp"
}

variable "dns_prefix" {
  description = "DNS prefix for VM public addreses"
  type = "string"
  default = "wrkshp"
}

variable "region" {
  description = "Azure region to use"
  type = "string"
  default = "westus2"
}

variable "win_image_vhd_uri" {
  description = "URI of the windows VHD to use as the VM image"
  type = "string"
  default = "https://mikergdisks645.blob.core.windows.net/osimages/ws2016-1706-ee-osDisk.21ee6c93-c674-41c8-9a44-3fb01082f67a.vhd?st=2017-08-17T22%3A49%3A00Z&se=2019-08-18T22%3A49%3A00Z&sp=rl&sv=2016-05-31&sr=b&sig=OVxi6yds2SOl4MPxdRYLkjdlzTYCbF264mpymeS2Tgc%3D"
}

variable "lin_image_vhd_uri" {
  description = "URI of the linux VHD to use as the VM image"
  type = "string"
  default = "https://mikergdisks645.blob.core.windows.net/osimages/ubuntu-1604-1706-ee-osDisk.9811daed-7556-47ec-a636-16457e9c645d.vhd?st=2017-08-17T22%3A49%3A00Z&se=2019-08-18T22%3A49%3A00Z&sp=rl&sv=2016-05-31&sr=b&sig=8zOiCewZ%2F7Gck9%2F4Hozaphz%2Bzq04cPZwhY%2FQMfPIA7o%3D"
}

variable "cluster_count" {
  description = "Number of clusters to create"
  type = "string"
  default = "1"
}

variable "vm_size" {
  description = "VM size to create"
  type = "string"
  default = "Standard_DS2_v2"
}

variable "azure_dns_suffix" {
    description = "Azure DNS suffix for public addresses"
    default = "cloudapp.azure.com"
}
