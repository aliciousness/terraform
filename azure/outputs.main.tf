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