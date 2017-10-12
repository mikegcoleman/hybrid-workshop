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
  default="https://mikewest.blob.core.windows.net/osimages/ws2016-10-10-2017-osDisk.7073f308-b14f-4c7c-be8b-bff06f5f2388.vhd?st=2017-10-12T01%3A18%3A00Z&se=2018-10-13T01%3A18%3A00Z&sp=rl&sv=2016-05-31&sr=b&sig=3C4n5WbDZ1PXGHP4K7Wes5G20p9gIazECRrGBvl8e8g%3D"
}

variable "lin_image_vhd_uri" {
  description = "URI of the linux VHD to use as the VM image"
  type = "string"
  default = "https://mikewest.blob.core.windows.net/osimages/ubuntu1604-10-10-2017-osDisk.dacfb97b-c826-4c8c-9f97-34d66fcad46a.vhd?st=2017-10-12T01%3A18%3A00Z&se=2018-10-13T01%3A18%3A00Z&sp=rl&sv=2016-05-31&sr=b&sig=sCY1lptno4KkPdIDF%2BIt2jW0q%2FTbqVyUucwrfwAhx74%3D"
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
