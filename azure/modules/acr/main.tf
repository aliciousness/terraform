resource "azurerm_resource_group" "acr" {
  name     = "RG${var.application}${var.environment}"
  location = "East US"
  tags = {
    "creator"               = var.terraform_tags[0]
    "author"                = var.terraform_tags[1]
    "module"                = var.terraform_tags[2]
  }
}

resource "azurerm_container_registry" "acr" {
  name                = "ContainerRegistry01${var.application}${var.environment}"
  resource_group_name = azurerm_resource_group.acr.name
  location            = azurerm_resource_group.acr.location
  sku                 = "Basic"
  admin_enabled       = true
  tags = {
    "creator"               = var.terraform_tags[0]
    "author"                = var.terraform_tags[1]
    "module"                = var.terraform_tags[2]
  }
}

resource "azurerm_container_registry_scope_map" "acr" {
  name                    = "${var.application}-${var.environment}-scope-map"
  container_registry_name = azurerm_container_registry.acr.name
  resource_group_name     = azurerm_resource_group.acr.name
  actions = [
    "repositories/my-acr-image/content/read",
    "repositories/my-acr-image/content/write",
    "repositories/my-acr-image/content/delete",
    "repositories/my-acr-image/metadata/read",
    "repositories/my-acr-image/metadata/write"
  ]
}

resource "azurerm_container_registry_token" "acr" {
  name                    = "${var.application}${var.environment}ACRtoken"
  container_registry_name = azurerm_container_registry.acr.name
  resource_group_name     = azurerm_resource_group.acr.name
  scope_map_id            = azurerm_container_registry_scope_map.acr.id
  enabled                 = "${var.acr-token-enabled}"
}

resource "azurerm_container_registry_token_password" "acr" {
  container_registry_token_id = azurerm_container_registry_token.acr.id

  password1 {

  }
  password2 {

  }
}