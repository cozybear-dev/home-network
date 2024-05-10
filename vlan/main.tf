resource "opnsense_interfaces_vlan" "vlan" {
  description = var.description
  tag         = var.tag
  priority    = 0
  parent      = var.parent
}

resource "unifi_network" "vlan" {
  name    = var.name
  purpose = "vlan-only"
  vlan_id = var.tag
}

resource "opnsense_firewall_alias" "net_alias" {
  name = var.name

  type = "network"
  content = [
    "192.168.${var.tag}.0/24"
  ]

  ip_protocol = null
  stats       = true
  description = "${var.name} - VLAN ${var.tag}"
}

resource "opnsense_firewall_alias" "ip_alias" {
  name = "${var.name}ip"

  type = "host"
  content = [
    "192.168.${var.tag}.1"
  ]

  ip_protocol = null
  stats       = true
  description = "DNS ${var.name} - VLAN ${var.tag}"
}

module "firewall_rules" {
  source = "../firewall"

  firewall  = var.firewall
  interface = var.interface
}
