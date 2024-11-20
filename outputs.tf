output "vmpasswd" {
  value = azurerm_windows_virtual_machine.test-res.admin_password
  sensitive = true
}