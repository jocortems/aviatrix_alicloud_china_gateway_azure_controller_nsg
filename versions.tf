terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.52.0"
    }
    alicloud = {
      source = "aliyun/alicloud"
      version = "~> 1.203.0"
    }
}
}

provider azurerm {
    alias = "aviatrix-controller"
    tenant_id = local.controller_tenant_id
    subscription_id = local.controller_subscription_id
    environment = "china"
    features {}
}

provider "alicloud" {
  region = var.gateway_region
}