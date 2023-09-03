output "rg_id" {
    value       = module.acr.rg_id
    description = "The ID of the resource group"
}

output "server_login" {
    value       = module.acr.server_login
    description = "The URL that can be used to log into the container registry"
}

output "admin_u" {
    value       = module.acr.admin_u
    description = "Admin username" 
}

output "admin_p" {
    value       = module.acr.admin_p
    description = "Admin password"
    sensitive = true 
}

output "acr_token_name" {
    value       = module.acr.acr_token_name
    description = "The name of the token"
}

output "acr_token_id" {
    value       = module.acr.acr_token_id
    description = "Token for Azure Container Registry"
    sensitive   = true
}

output "acr_password1" {
    value       = module.acr.acr_password1
    description = "The value of password one for the ACR token"
    sensitive   = true
}

output "acr_password2" {
    value       = module.acr.acr_password2
    description = "The value of password two for the ACR token"
    sensitive   = true
}