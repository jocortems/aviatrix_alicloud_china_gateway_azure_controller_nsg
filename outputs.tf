output "gateway_address" {
  value = local.gateway_address
}

output "gatewayha_address" {
  value = local.gatewayha_address
}

output "gateway_eip_id" {
  value = join(",", [for eip in data.alicloud_eip_addresses.avx_gw.addresses : eip.id])
}

output "gatewayha_eip_id" {
  value = var.ha_enabled ? join(",", [for eip in data.alicloud_eip_addresses.avx_gwha[0].addresses : eip.id]) : null
}