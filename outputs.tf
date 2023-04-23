output "gateway_address" {
  value = local.gateway_address
}

output "gatewayha_address" {
  value = var.ha_enabled ? [for eip in data.alicloud_eip_addresses.avx_gwha[0].addresses : eip.ip_address] : null  
}