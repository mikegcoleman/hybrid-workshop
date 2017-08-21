resource "azurerm_virtual_network" "workshop" {
    name = "${var.dns_prefix}-workshop-virtnet"
    address_space = ["10.0.0.0/16"]
    location = "${var.region}"
    resource_group_name = "${azurerm_resource_group.global.name}"
}

resource "azurerm_subnet" "workshop" {
    name = "${var.dns_prefix}-workshop-sn"
    resource_group_name = "${azurerm_resource_group.global.name}"
    virtual_network_name = "${azurerm_virtual_network.workshop.name}"
    address_prefix = "10.0.2.0/24"
}

# Create Windows NIC's and IPs
resource "azurerm_network_interface" "windows-a" {
    count                        = "${var.cluster_count}"
    name = "win-${format("%02d", count.index + 1)}-nic-a"
    location = "${var.region}"
    resource_group_name = "${azurerm_resource_group.global.name}"

    ip_configuration {
        name = "win-${format("%02d", count.index + 1)}-a-config"
        subnet_id = "${azurerm_subnet.workshop.id}"
        public_ip_address_id          = "${element(azurerm_public_ip.windows-a.*.id, count.index)}"
        private_ip_address_allocation = "dynamic"
    }
}

resource "azurerm_public_ip" "windows-a" {
  count                        = "${var.cluster_count}"
  domain_name_label            = "${var.dns_prefix}-win-${format("%02d", count.index + 1)}-a"
  idle_timeout_in_minutes      = 30
  location                     = "${var.region}"
  name                         = "win-${format("%02d", count.index + 1)}-publicip-a"
  public_ip_address_allocation = "dynamic"
  resource_group_name          = "${azurerm_resource_group.global.name}"
}

resource "azurerm_network_interface" "windows-b" {
    count                        = "${var.cluster_count}"
    name = "win-${format("%02d", count.index + 1)}-nic-b"
    location = "${var.region}"
    resource_group_name = "${azurerm_resource_group.global.name}"

    ip_configuration {
        name = "win-${format("%02d", count.index + 1)}-b-config"
        subnet_id = "${azurerm_subnet.workshop.id}"
        public_ip_address_id          = "${element(azurerm_public_ip.windows-b.*.id, count.index)}"
        private_ip_address_allocation = "dynamic"
    }
}

resource "azurerm_public_ip" "windows-b" {
  count                        = "${var.cluster_count}"
  domain_name_label            = "${var.dns_prefix}-win-${format("%02d", count.index + 1)}-b"
  idle_timeout_in_minutes      = 30
  location                     = "${var.region}"
  name                         = "win-${format("%02d", count.index + 1)}-publicip-b"
  public_ip_address_allocation = "dynamic"
  resource_group_name          = "${azurerm_resource_group.global.name}"
}


# Create Linux NIC's and IPs
resource "azurerm_network_interface" "linux-a" {
    count                        = "${var.cluster_count}"
    name = "lin-${format("%02d", count.index + 1)}-nic-a"
    location = "${var.region}"
    resource_group_name = "${azurerm_resource_group.global.name}"

    ip_configuration {
        name = "lin-${format("%02d", count.index + 1)}-a-config"
        subnet_id = "${azurerm_subnet.workshop.id}"
        public_ip_address_id          = "${element(azurerm_public_ip.linux-a.*.id, count.index)}"
        private_ip_address_allocation = "dynamic"
    }
}

resource "azurerm_public_ip" "linux-a" {
  count                        = "${var.cluster_count}"
  domain_name_label            = "${var.dns_prefix}-lin-${format("%02d", count.index + 1)}-a"
  idle_timeout_in_minutes      = 30
  location                     = "${var.region}"
  name                         = "lin-${format("%02d", count.index + 1)}-publicip-a"
  public_ip_address_allocation = "dynamic"
  resource_group_name          = "${azurerm_resource_group.global.name}"
}

resource "azurerm_network_interface" "linux-b" {
    count                        = "${var.cluster_count}"
    name = "lin-${format("%02d", count.index + 1)}-nic-b"
    location = "${var.region}"
    resource_group_name = "${azurerm_resource_group.global.name}"

    ip_configuration {
        name = "lin-${format("%02d", count.index + 1)}-b-config"
        subnet_id = "${azurerm_subnet.workshop.id}"
        public_ip_address_id          = "${element(azurerm_public_ip.linux-b.*.id, count.index)}"
        private_ip_address_allocation = "dynamic"
    }
}

resource "azurerm_public_ip" "linux-b" {
  count                        = "${var.cluster_count}"
  domain_name_label            = "${var.dns_prefix}-lin-${format("%02d", count.index + 1)}-b"
  idle_timeout_in_minutes      = 30
  location                     = "${var.region}"
  name                         = "lin-${format("%02d", count.index + 1)}-publicip-b"
  public_ip_address_allocation = "dynamic"
  resource_group_name          = "${azurerm_resource_group.global.name}"
}

resource "azurerm_network_interface" "linux-c" {
    count                        = "${var.cluster_count}"
    name = "lin-${format("%02d", count.index + 1)}-nic-c"
    location = "${var.region}"
    resource_group_name = "${azurerm_resource_group.global.name}"

    ip_configuration {
        name = "lin-${format("%02d", count.index + 1)}-c-config"
        subnet_id = "${azurerm_subnet.workshop.id}"
        public_ip_address_id          = "${element(azurerm_public_ip.linux-c.*.id, count.index)}"
        private_ip_address_allocation = "dynamic"
    }
}

resource "azurerm_public_ip" "linux-c" {
  count                        = "${var.cluster_count}"
  domain_name_label            = "${var.dns_prefix}-lin-${format("%02d", count.index + 1)}-c"
  idle_timeout_in_minutes      = 30
  location                     = "${var.region}"
  name                         = "lin-${format("%02d", count.index + 1)}-publicip-c"
  public_ip_address_allocation = "dynamic"
  resource_group_name          = "${azurerm_resource_group.global.name}"
}

# build windows vms

resource "azurerm_storage_container" "windows-a" {
  container_access_type = "private"
  count                 = "${var.cluster_count}"
  name                  = "windows-${format("%02d", count.index + 1)}-a-storage"
  resource_group_name   = "${azurerm_resource_group.global.name}"
  storage_account_name  = "${azurerm_storage_account.global.name}"
}

resource "azurerm_virtual_machine" "windows-a" {
    count                        = "${var.cluster_count}"
    name = "win-${format("%02d", count.index + 1)}-vm-a"
    location = "${var.region}"
    resource_group_name = "${azurerm_resource_group.global.name}"
    network_interface_ids = ["${element(azurerm_network_interface.windows-a.*.id, count.index)}"]
    vm_size = "${var.vm_size}"

    storage_os_disk {
        name = "windows-${format("%02d", count.index + 1)}-a-osdisk"
        vhd_uri = "${azurerm_storage_account.global.primary_blob_endpoint}${element(azurerm_storage_container.windows-a.*.id, count.index)}/disk1.vhd"
        caching = "ReadWrite"
        create_option = "FromImage"
        image_uri = "https://${azurerm_storage_account.global.name}.blob.core.windows.net/${azurerm_storage_container.global.name}/${azurerm_storage_blob.windows.name}"
        os_type = "windows"
    }

    os_profile {
        computer_name = "${var.dns_prefix}-win-${format("%02d", count.index + 1)}-a"
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

resource "azurerm_storage_container" "windows-b" {
  container_access_type = "private"
  count                 = "${var.cluster_count}"
  name                  = "windows-${format("%02d", count.index + 1)}-b-storage"
  resource_group_name   = "${azurerm_resource_group.global.name}"
  storage_account_name  = "${azurerm_storage_account.global.name}"
}

resource "azurerm_virtual_machine" "windows-b" {
    count                        = "${var.cluster_count}"
    name = "win-${format("%02d", count.index + 1)}-vm-b"
    location = "${var.region}"
    resource_group_name = "${azurerm_resource_group.global.name}"
    network_interface_ids = ["${element(azurerm_network_interface.windows-b.*.id, count.index)}"]
    vm_size = "${var.vm_size}"

    storage_os_disk {
        name = "windows-${format("%02d", count.index + 1)}-b-osdisk"
        vhd_uri = "${azurerm_storage_account.global.primary_blob_endpoint}${element(azurerm_storage_container.windows-b.*.id, count.index)}/disk1.vhd"
        caching = "ReadWrite"
        create_option = "FromImage"
        image_uri = "https://${azurerm_storage_account.global.name}.blob.core.windows.net/${azurerm_storage_container.global.name}/${azurerm_storage_blob.windows.name}"
        os_type = "windows"
    }

    os_profile {
        computer_name = "${var.dns_prefix}-win-${format("%02d", count.index + 1)}-b"
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

resource "azurerm_storage_container" "linux-a" {
  container_access_type = "private"
  count                 = "${var.cluster_count}"
  name                  = "linux-${format("%02d", count.index + 1)}-a-storage"
  resource_group_name   = "${azurerm_resource_group.global.name}"
  storage_account_name  = "${azurerm_storage_account.global.name}"
}

resource "azurerm_virtual_machine" "linux-a" {
    count                        = "${var.cluster_count}"
    name = "lin-${format("%02d", count.index + 1)}-vm-a"
    location = "${var.region}"
    resource_group_name = "${azurerm_resource_group.global.name}"
    network_interface_ids = ["${element(azurerm_network_interface.linux-a.*.id, count.index)}"]
    vm_size = "${var.vm_size}"

    storage_os_disk {
        name = "linux-${format("%02d", count.index + 1)}-a-osdisk"
        vhd_uri = "${azurerm_storage_account.global.primary_blob_endpoint}${element(azurerm_storage_container.linux-a.*.id, count.index)}/disk1.vhd"
        caching = "ReadWrite"
        create_option = "FromImage"
        image_uri = "https://${azurerm_storage_account.global.name}.blob.core.windows.net/${azurerm_storage_container.global.name}/${azurerm_storage_blob.linux.name}"
        os_type = "linux"
    }

    os_profile {
        computer_name = "${var.dns_prefix}-lin-${format("%02d", count.index + 1)}-a"
        admin_username = "docker"
        admin_password = "Docker2017"
    }

    os_profile_linux_config {
        disable_password_authentication = false
    }

    tags {
        environment = "staging"
    }
}

resource "azurerm_storage_container" "linux-b" {
  container_access_type = "private"
  count                 = "${var.cluster_count}"
  name                  = "linux-${format("%02d", count.index + 1)}-b-storage"
  resource_group_name   = "${azurerm_resource_group.global.name}"
  storage_account_name  = "${azurerm_storage_account.global.name}"
}

resource "azurerm_virtual_machine" "linux-b" {
    count                        = "${var.cluster_count}"
    name = "lin-${format("%02d", count.index + 1)}-vm-b"
    location = "${var.region}"
    resource_group_name = "${azurerm_resource_group.global.name}"
    network_interface_ids = ["${element(azurerm_network_interface.linux-b.*.id, count.index)}"]
    vm_size = "${var.vm_size}"

    storage_os_disk {
        name = "linux-${format("%02d", count.index + 1)}-b-osdisk"
        vhd_uri = "${azurerm_storage_account.global.primary_blob_endpoint}${element(azurerm_storage_container.linux-b.*.id, count.index)}/disk1.vhd"
        caching = "ReadWrite"
        create_option = "FromImage"
        image_uri = "https://${azurerm_storage_account.global.name}.blob.core.windows.net/${azurerm_storage_container.global.name}/${azurerm_storage_blob.linux.name}"
        os_type = "linux"
    }

    os_profile {
        computer_name = "${var.dns_prefix}-lin-${format("%02d", count.index + 1)}-b"
        admin_username = "docker"
        admin_password = "Docker2017"
    }

   os_profile_linux_config {
        disable_password_authentication = false
    }

    tags {
        environment = "staging"
    }
}

resource "azurerm_storage_container" "linux-c" {
  container_access_type = "private"
  count                 = "${var.cluster_count}"
  name                  = "linux-${format("%02d", count.index + 1)}-c-storage"
  resource_group_name   = "${azurerm_resource_group.global.name}"
  storage_account_name  = "${azurerm_storage_account.global.name}"
}

resource "azurerm_virtual_machine" "linux-c" {
    count                        = "${var.cluster_count}"
    name = "lin-${format("%02d", count.index + 1)}-vm-c"
    location = "${var.region}"
    resource_group_name = "${azurerm_resource_group.global.name}"
    network_interface_ids = ["${element(azurerm_network_interface.linux-c.*.id, count.index)}"]
    vm_size = "${var.vm_size}"

    storage_os_disk {
        name = "linux-${format("%02d", count.index + 1)}-b-osdisk"
        vhd_uri = "${azurerm_storage_account.global.primary_blob_endpoint}${element(azurerm_storage_container.linux-c.*.id, count.index)}/disk1.vhd"
        caching = "ReadWrite"
        create_option = "FromImage"
        image_uri = "https://${azurerm_storage_account.global.name}.blob.core.windows.net/${azurerm_storage_container.global.name}/${azurerm_storage_blob.linux.name}"
        os_type = "linux"
    }

    os_profile {
        computer_name = "${var.dns_prefix}-lin-${format("%02d", count.index + 1)}-c"
        admin_username = "docker"
        admin_password = "Docker2017"
    }

    os_profile_linux_config {
        disable_password_authentication = false
    }

    tags {
        environment = "staging"
    }
}
