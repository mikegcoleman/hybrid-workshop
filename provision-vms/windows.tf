resource "azurerm_virtual_network" "workshop" {
    name = "workshop-virtnet"
    address_space = ["10.0.0.0/16"]
    location = "${var.region}"
    resource_group_name = "${azurerm_resource_group.global.name}"
}

resource "azurerm_subnet" "workshop" {
    name = "workshop-${format("%02d", count.index + 1)}-sn"
    resource_group_name = "${azurerm_resource_group.global.name}"
    virtual_network_name = "${azurerm_virtual_network.workshop.name}"
    address_prefix = "10.0.2.0/24"
}

# Create Windows NIC's and IPs
resource "azurerm_network_interface" "windows" {
    count                        = "${var.win_vm_count}"
    name = "win-${format("%02d", count.index + 1)}-nic"
    location = "${var.region}"
    resource_group_name = "${azurerm_resource_group.global.name}"

    ip_configuration {
        name = "testconfiguration1"
        subnet_id = "${azurerm_subnet.workshop.id}"
        public_ip_address_id          = "${element(azurerm_public_ip.windows.*.id, count.index)}"
        private_ip_address_allocation = "dynamic"
    }
}

resource "azurerm_public_ip" "windows" {
  count                        = "${var.win_vm_count}"
  domain_name_label            = "${var.dns_prefix}-win-${format("%02d", count.index + 1)}"
  idle_timeout_in_minutes      = 30
  location                     = "${var.region}"
  name                         = "win-${format("%02d", count.index + 1)}-publicip"
  public_ip_address_allocation = "dynamic"
  resource_group_name          = "${azurerm_resource_group.global.name}"
}

# Create Linux NIC's and IPs
resource "azurerm_network_interface" "linux" {
    count                        = "${var.lin_vm_count}"
    name = "lin-${format("%02d", count.index + 1)}-nic"
    location = "${var.region}"
    resource_group_name = "${azurerm_resource_group.global.name}"

    ip_configuration {
        name = "testconfiguration1"
        subnet_id = "${azurerm_subnet.workshop.id}"
        public_ip_address_id          = "${element(azurerm_public_ip.linux.*.id, count.index)}"
        private_ip_address_allocation = "dynamic"
    }
}

resource "azurerm_public_ip" "linux" {
  count                        = "${var.lin_vm_count}"
  domain_name_label            = "${var.dns_prefix}-lin-${format("%02d", count.index + 1)}"
  idle_timeout_in_minutes      = 30
  location                     = "${var.region}"
  name                         = "lin-${format("%02d", count.index + 1)}-publicip"
  public_ip_address_allocation = "dynamic"
  resource_group_name          = "${azurerm_resource_group.global.name}"
}

# build windows vms

resource "azurerm_storage_container" "windows" {
  container_access_type = "private"
  count                 = "${var.win_vm_count}"
  name                  = "windows-${format("%02d", count.index + 1)}-storage"
  resource_group_name   = "${azurerm_resource_group.global.name}"
  storage_account_name  = "${azurerm_storage_account.global.name}"
}

resource "azurerm_virtual_machine" "windows" {
    count                        = "${var.win_vm_count}"
    name = "win-${format("%02d", count.index + 1)}-vm"
    location = "${var.region}"
    resource_group_name = "${azurerm_resource_group.global.name}"
    network_interface_ids = ["${element(azurerm_network_interface.windows.*.id, count.index)}"]
    vm_size = "${var.vm_size}"

    storage_os_disk {
        name = "windows-${format("%02d", count.index + 1)}-osdisk"
        vhd_uri = "${azurerm_storage_account.global.primary_blob_endpoint}${element(azurerm_storage_container.windows.*.id, count.index)}/disk1.vhd"
        caching = "ReadWrite"
        create_option = "FromImage"
        image_uri = "https://${azurerm_storage_account.global.name}.blob.core.windows.net/${azurerm_storage_container.global.name}/${azurerm_storage_blob.windows.name}"
        os_type = "windows"
    }

    os_profile {
        computer_name = "${var.dns_prefix}-win-${format("%02d", count.index + 1)}"
        admin_username = "docker"
        admin_password = "Docker2017"
    }

    os_profile_windows_config {
        provision_vm_agent = true
        enable_automatic_upgrades = false
    }

    tags {
        environment = "staging"
    }
}

# build Linux vms

resource "azurerm_storage_container" "linux" {
  container_access_type = "private"
  count                 = "${var.lin_vm_count}"
  name                  = "linux-${format("%02d", count.index + 1)}-storage"
  resource_group_name   = "${azurerm_resource_group.global.name}"
  storage_account_name  = "${azurerm_storage_account.global.name}"
}

resource "azurerm_virtual_machine" "linux" {
    count                        = "${var.lin_vm_count}"
    name = "lin-${format("%02d", count.index + 1)}-vm"
    location = "${var.region}"
    resource_group_name = "${azurerm_resource_group.global.name}"
    network_interface_ids = ["${element(azurerm_network_interface.linux.*.id, count.index)}"]
    vm_size = "${var.vm_size}"

    storage_os_disk {
        name = "linux-${format("%02d", count.index + 1)}-osdisk"
        vhd_uri = "${azurerm_storage_account.global.primary_blob_endpoint}${element(azurerm_storage_container.linux.*.id, count.index)}/disk1.vhd"
        caching = "ReadWrite"
        create_option = "FromImage"
        image_uri = "https://${azurerm_storage_account.global.name}.blob.core.windows.net/${azurerm_storage_container.global.name}/${azurerm_storage_blob.linux.name}"
        os_type = "linux"
    }

    os_profile {
        computer_name = "${var.dns_prefix}-lin-${format("%02d", count.index + 1)}"
        admin_username = "docker"
        admin_password = "Docker2017"
    }
/*
    os_profile_linux_config {
        disable_password_authentication = false
    }
*/
    tags {
        environment = "staging"
    }
}
