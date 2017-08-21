#VM Setup Instructions

The workshop can be setup using the provided Terraform scripts for Azure. You will, of course, need Terraform on some workstation in order to execute the scripts.

If you cannot use the Terraform, or you wish to use some other infrastructure besides Azure, you will need to build your images manually. 

##Using Terraform

### Azure Permissions
In order to use the Terraform script you will need a service principal account with `contributor` permissions. Consult the Azure documentation on how to create a Service Principal account and assign the appropriate permissions.

### Terraform files
There are three terraform files include

* `init.tf`: Creates some initial non-workshop dependent Azure resources, as well as contains your service principal information (which you will need to supply and should take great care to protect)


* `variables.tf`: Holds variables unique to your workshop. Many of which you'll want to change (see below)

* `windows.tf`: Provisions out the bulk of the workshop infrastructure including VMs, storage accounts, NICs, Public IPs, etc. You should not need to modify this file. 

#### Modifying `init.tf`
The only thing you'll need to modify in the `init.tf` file are inputs for the AzureRM provider. This is the very first item in the file. Please see the Azure documentation on how to create and retrieve the necessary credentials. 

```
provider "azurerm" {
  subscription_id = "Your Azure Subcription ID"
  client_id       = "Your Service Principal ID"
  client_secret   = "Your Service Principal Secret"
  tenant_id       = "Your Azure Tenant ID"
}
```

#### Modifying `variables.tf`
There are a number of variables that you will need to configure in the `variables.tf` file. To do this change the `default` value for the individual variable. Be sure to adhere to any naming restrictions when naming your resources (see Azure documentation for more specifics)

Here is a list of the available parameters. 

* `resource_group`: You must createa  NEW azure resource group. Supply the name here. 

* `storage_account`: You must create a NEW storage account. Supply the name here. 

* `dns_prefix`: This becomes the firt part of the hostname and resource names. Use something that uniquely identifies this workshop - such as an airport code. See the workshop readme for more information on how VMs are named. 

* `region`: The region in which your resources will be created. Ensure that you have appropriate quotas for whatever region you choose. 

* `win_image_vhd_uri`: This is the base image for your Windows VMs. There is a default supplied, but you can change it if you want to build your own image (instructions on creating Azure images is out of scope for this document)

* `lin_image_vhd_uri`: This is the base image for your Linux VMs. There is a default supplied, but you can change it if you want to build your own image (instructions on creating Azure images is out of scope for this document)

* `cluster_count`: The total number of clusters to create. For instance if you have 25 students you create 25 clusters (or 26 if you want one for yourself)

* `vm_size`: The Azure VM size to use. The default is dual core w/ 7GB of RAM. This seems to be the minimum to get Windows to perform adequately. 

* `azure_dns_suffix`: This is appended to the generated hostname to provide the FQDN. You should not need to change this. 

### Using Terrform to create the workshop infrastructure
Terrafor has a bunch of different commands, but for this workshop you only need to use one, aothough there are two additional ones that could prove handy. 
	
* `terraform apply`: This will actually create the workshop VMs. Regardless of the number of VMs you create, it will take a minimum of 45 minutes for the script to run. Each VM adds a bit of time to this, so figure 1-2 hours total to do a decent size provisioning job

* `terraform plan`: This will give you a readout of exactly what Terraform would create if you were to run 'terraform apply`. Useful to make sure your naming conventions make sense, and there aren't any bugs in your script. 

* `terraform destroy`: This will delete everything terraform provisioned. The reality is that's easier and quicker to actually just delete the resource group in Azure

> **Note**: If you choose to delete the resource group in Azure, you will need to manually delete the `tfstate` file on your workstation before you deploy another workshop. Terraform uses this file to track state, and will think you are trying to update an existing configuration when you run `apply` again if you don't delete it. 

### Printing VM information cards
To create a file that includes the student information cards, use the `list_vm_ips.sh` script in the utilities directory and redirect the output to a file. You will need to supply the number of clusters and the resource group name. 

	$ ./list_vm_ips.sh 45 mike-pdx
	
The above command will print out information cards for the first 45 VMs in the `mike-pdx` resource group. 

> **Note**: As of right now the list is a simple text file, you will need to add page breaks in order for it to print correctly. 

##Building the base images manually
If you cannot (do not want to use) the provided Terraform scripts, you will need to build you base images manually, and then use some alternative deployment methodology (the exact methodology is up to you, and out of scope for this document) 

The workshop is currently designed to use three Linux nodes, and two windows nodes. With all the nodes being indentically configured as detailed below. 

###Linux

The workshop uses Ubuntu 16.04 as the base image. Additionally, you should:

* Create a `docker` user with password `Docker2017`. Give the account `sudo` privileges


* Install Docker 17.06 EE


* Ensure the `docker` user is added to the `docker` group 
	
		$ sudo usermod -aG docker docker
		
* Copy the `copy_certs.sh` script (which can be found in the `utilities` directory) into the `docker` user's home directory

###Windows
Use a Windows Server 2016 base image (with all the latest updates). Additionally you should:

* Create an admin account with the username `docker` and password `Docker2017`


* Install Docker EE 17.06


* Disable Windows Firewall


* Disable Internet Enhanced Security Configuration (IESC)


* Disable Windows Defender


* Install `git`


* Copy the `copy_certs.ps1` script (which can be found in the `utilities` directory into `C:\`


* Copy this VHD as `C:\ws2016.vhd`

* Prepull the following Docker images:

	* `microsoft/windowsservercore:latest`
	* `microsoft/iis:latest`
	* `microsoft/nanoserver:latest`
	* `<at sea database>`
	* `<specific version of iis>`
	* `UCP windows images`

* Run the UCP Windows Preparation Script: `<need url>`

