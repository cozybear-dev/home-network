locals {
  configuration = yamldecode(file("${path.root}/configuration.yaml"))
}

resource "opnsense_firewall_alias" "PrivateNetworks" {
  name = "PrivateNetworks"

  type = "network"
  content = [
    "10.0.0.0/8",
    "172.16.0.0/12",
    "192.168.0.0/16"
  ]

  ip_protocol = null
  stats       = true
  description = "All local networks (ipv4 only)"
}

# module "firewall_rules" {
#   source = "./firewall"

#   for_each = local.configuration["firewall"]

#   firewall  = local.configuration["firewall"][each.key]
#   interface = each.key
# }

module "vlan" {
  source = "./vlan"

  for_each = local.configuration["vlans"]

  name        = each.key
  description = each.value.description
  parent      = "em1"
  tag         = each.value.tag
  interface   = each.value.interface
  firewall    = each.value.firewall
}

data "bitwarden_item_login" "wlan_pass" {
  for_each = local.configuration["unifi"]["wlan"]
  search   = each.key
}

data "unifi_ap_group" "default" {
}

data "unifi_user_group" "default" {
}

resource "unifi_wlan" "wlan" {
  for_each = local.configuration["unifi"]["wlan"]

  name       = each.key
  passphrase = data.bitwarden_item_login.wlan_pass[each.key].password
  security   = "wpapsk"

  l2_isolation = can(each.value.isolation) ? each.value.isolation : false

  wpa3_support    = can(each.value.wpa3) ? each.value.wpa3 : false
  wpa3_transition = can(each.value.wpa3) ? each.value.wpa3 : false
  pmf_mode        = can(each.value.wpa3) ? "optional" : "disabled"

  network_id    = module.vlan[each.value.vlan].unifi_vlan_id
  ap_group_ids  = [data.unifi_ap_group.default.id]
  user_group_id = data.unifi_user_group.default.id
}

data "unifi_network" "Default" {
  name = "Default"
}

resource "unifi_port_profile" "profile" {
  for_each = local.configuration["unifi"]["port_profiles"]

  name                  = each.key
  forward               = each.value.forward
  native_networkconf_id = can(module.vlan[each.key].unifi_vlan_id) ? module.vlan[each.key].unifi_vlan_id : can(each.value.vlan) ? module.vlan[each.value.vlan].unifi_vlan_id : can(each.value.network == "Default") ? data.unifi_network.Default.id : null
  port_security_enabled = can(each.value.port_security) ? each.value.port_security : false

  egress_rate_limit_kbps         = can(each.value.egress) ? each.value.egress : 9999999
  egress_rate_limit_kbps_enabled = can(each.value.egress) ? true : false

  poe_mode = "auto"
}

resource "unifi_device" "device" {
  for_each = local.configuration["unifi"]["devices"]

  name = each.key
  mac  = each.value.mac

  dynamic "port_override" {
    for_each = each.value.ports
    content {
      number          = port_override.key
      name            = port_override.value.name
      port_profile_id = unifi_port_profile.profile[port_override.value.profile].id
    }
  }
}