output "rg_id" {
    value       = azurerm_resource_group.acr.id
    description = "The ID of the resource group"
}

output "server_login" {
    value       = azurerm_container_registry.acr.login_server
    description = "The URL that can be used to log into the container registry"
}

output "admin_u" {
    value       = azurerm_container_registry.acr.admin_username
    description = "Admin username" 
}

output "admin_p" {
    value       = azurerm_container_registry.acr.admin_password
    description = "Admin password" 
    sensitive   = true
}

output "acr_token_id" {
    value       = azurerm_container_registry_token.acr.id
    description = "Token for Azure Container Registry"
    sensitive   = true
}

output "acr_token_name" {
    value       = azurerm_container_registry_token.acr.name
    description = "The name of the token"
}

output "acr_password1" {
    value       = azurerm_container_registry_token_password.acr.password1
    description = "The value of password one for the ACR token"
}

output "acr_password2" {
    value       = azurerm_container_registry_token_password.acr.password2
    description = "The value of password two for the ACR token"
}