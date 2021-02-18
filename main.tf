terraform {
 backend "azurerm" {
    resource_group_name   = "Terraform"
    storage_account_name  = "bhlokanatfstate"
    container_name        = "internal-expense-app-tfstate"
    key                   = "terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
}

module "ResourceGroup" {
  source    = "./InfrastructureAsCode/Modules/Terraform/ResourceGroup"
  resource_group_name     = var.resource_group_name
  resource_group_location = var.resource_group_location
}

module "VirtualNetwork" {
  source                        = "./InfrastructureAsCode/Modules/Terraform/VirtualNetwork"
  virtual_network_name          = var.virtual_network_name
  resource_group_name           = var.resource_group_name
  resource_group_location       = var.resource_group_location
  virtual_network_address_space = var.virtual_network_address_space
}

module "Subnet" {
  source               = "./InfrastructureAsCode/Modules/Terraform/Subnet"
  subnet_name          = var.ase_subnet_name
  resource_group_name  = var.resource_group_name
  virtual_network_name = module.VirtualNetwork.virtual_network_name
  subnet_address_space = var.ase_subnet_address_space
}