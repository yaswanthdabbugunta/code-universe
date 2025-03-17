
variable "resource_group_location" {
  type        = string
  description = "centralindia"
}

variable "resource_group_name_web" {
  type        = string
  description = "Resource Group - Web"
}

variable "virtual_network_name" {
  type        = string
  description = "Virtual Network - Name"
}
variable "subnet_name" {
  type        = string
  description = "Subnet Network - Name"
}
variable "nic_name" {
  type        = string
  description = "NIC Network - Name"
}
variable "vm_name" {
  type        = string
  description = "Virtual Machine - Name"
}

variable "network_security_group_name" {
  type        = string
  description = "Network Securty Group - Name"
}


variable "admin_username" {
  type        = string
  description = "Admin user name"
}


variable "public_ip_name" {
  type        = string
  description = "Public IP - Name"
}

variable "storage_boot_diag" {
  type        = string
  description = "Storage account for boot diagnostics"
}