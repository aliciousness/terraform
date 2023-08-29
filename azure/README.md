# This file is intended to be run line by line NOT as a script
- `$get_random=$(shuf -i 0-9 -n 3 | tr -d '\n')`
- `$RESOURCE_GROUP_NAME='tfstateRG01'` 
- `$STORAGE_ACCOUNT_NAME="tfstate01${get_random}"`
- `$CONTAINER_NAME='tfstate'`

---

### Verify you're using the correct account
`az account show`

---

### Create resource group
`az group create --name $RESOURCE_GROUP_NAME --location eastus`

---

### Create storage account
`az storage account create --resource-group $RESOURCE_GROUP_NAME --name $STORAGE_ACCOUNT_NAME --sku Standard_LRS --encryption-services blob`

---

### Create blob container
`az storage container create --name $CONTAINER_NAME --account-name $STORAGE_ACCOUNT_NAME`
##### Get the storage access key and store it as an environment variable `$ACCOUNT_KEY=$(az storage account keys list --resource-group $RESOURCE_GROUP_NAME --account-name $STORAGE_ACCOUNT_NAME --query '[0].value' -o tsv) $env:ARM_ACCESS_KEY=$ACCOUNT_KEY`

---

### Add the following block under the required_providers block in your Terraform providers file
```
backend "azurerm" { 
    resource_group_name = "tfstateRG01" 
    storage_account_name = "<storage_account_name>" <--- Be sure to update this with the correct value
    container_name = "tfstate" 
    key = "terraform.tfstate" <--- This will contain a unique name for the terraform stack you're deploying 
    }```json


