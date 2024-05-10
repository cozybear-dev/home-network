variable "interface" {
  type        = string
  description = "Specific the interface identifier of the assigned VLAN"
  default     = null
}

variable "firewall" {
  type        = any
  description = "All firewall rules to be applied on VLAN"
}