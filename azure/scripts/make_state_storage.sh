#!/bin/bash
get_random=$(shuf -i 0-9 -n 3 | tr -d '\n')
RESOURCE_GROUP_NAME=tfstateRG01
STORAGE_ACCOUNT_NAME=tfstate01${get_random}
CONTAINER_NAME=tfstate
echo "Storage Account name: $STORAGE_ACCOUNT_NAME"

# Create resource group
az group create --name $RESOURCE_GROUP_NAME --location eastus
# Create storage account
az storage account create --resource-group $RESOURCE_GROUP_NAME --name $STORAGE_ACCOUNT_NAME --sku Standard_LRS --encryption-services blob
# Create blob container
az storage container create --name $CONTAINER_NAME --account-name $STORAGE_ACCOUNT_NAME
# store account_key in a variable 
ACCOUNT_KEY=$(az storage account keys list --resource-group $RESOURCE_GROUP_NAME --account-name $STORAGE_ACCOUNT_NAME --query '[0].value' -o tsv) $env:ARM_ACCESS_KEY=$ACCOUNT_KEY
echo "Account key: $ACCOUNT_KEY"
