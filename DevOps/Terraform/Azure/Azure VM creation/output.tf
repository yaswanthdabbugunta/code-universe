output "vm_id" {
  value = azurerm_linux_virtual_machine.vm.id
}

output "vm_ip" {
  value = azurerm_linux_virtual_machine.vm.public_ip_addresses
}

output "tls_private_key" {
  value     = tls_private_key.example_ssh.private_key_pem
  sensitive = true
}