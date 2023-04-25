data "azurerm_subscriptions" "available" {
}

data "azurerm_subscription" "current" {
}

resource "time_sleep" "avx_gw" {
  create_duration   = "5m"
}

resource "time_sleep" "avx_gwha" {
  count = var.ha_enabled ? 1 : 0
  create_duration   = "14m"
}

data "alicloud_eip_addresses" "avx_gw" {
  depends_on = [
    time_sleep.avx_gw
  ]
  status = "InUse"
  name_regex = var.gateway_name
}

data "alicloud_eip_addresses" "avx_gwha" {
  count = var.ha_enabled ? 1 : 0
  depends_on = [
    time_sleep.avx_gwha
  ]
  status = "InUse"
  name_regex = "${var.gateway_name}-ha"
}

resource "azurerm_network_security_rule" "avx_controller_allow_gw" {
  provider                    = azurerm.aviatrix-controller
  name                        = format("ali-avx-%s-gw", var.gateway_name)
  resource_group_name         = var.controller_nsg_resource_group_name
  network_security_group_name = var.controller_nsg_name
  access                      = "Allow"  
  direction                   = "Inbound"
  priority                    = var.controller_nsg_rule_priority  
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "443"
  source_address_prefixes     = local.gateway_address
  destination_address_prefix  = "*"
  description                 = "Allow access to AliCloud Avaitrix Gateway ${var.gateway_name}"
}

resource "azurerm_network_security_rule" "avx_controller_allow_gwha" {
  count                       = var.ha_enabled ? 1 : 0
  provider                    = azurerm.aviatrix-controller
  name                        = format("ali-avx-%s-gwha", var.gateway_name)
  resource_group_name         = var.controller_nsg_resource_group_name
  network_security_group_name = var.controller_nsg_name
  access                      = "Allow"  
  direction                   = "Inbound"
  priority                    = var.controller_nsg_rule_priority + 1
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "443"
  source_address_prefixes     = local.gatewayha_address
  destination_address_prefix  = "*"
  description                 = "Allow access to AliCloud Avaitrix Gateway ${var.gateway_name}-hagw"
}