resource "opnsense_firewall_filter" "rule" {
  for_each = var.firewall != null ? var.firewall : {}

  enabled = true

  action = each.value.action

  direction = each.value.direction

  interface = [
    var.interface
  ]

  protocol = each.value.protocol

  source = {
    net  = can(each.value.source.net) ? each.value.source.net : var.interface
    port = can(each.value.source.port) ? each.value.source.port : ""
  }

  destination = {
    invert = can(each.value.destination.invert) ? each.value.destination.invert : false
    net    = each.value.destination.net
    port   = can(each.value.destination.port) ? each.value.destination.port : ""
  }

  log         = can(each.value.log) ? each.value.log : false
  description = "${each.key} - Managed by Terraform"
}