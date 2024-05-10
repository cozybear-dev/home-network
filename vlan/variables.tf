variable "name" {
  type        = string
  description = "Name of the VLAN"
}

variable "description" {
  type        = string
  description = "Description of the purpose of the VLAN"
}

variable "parent" {
  type        = string
  description = "OPNsense parent interface to bind the VLAN to"
}

variable "tag" {
  type        = number
  description = "VLAN tag number"
}

variable "interface" {
  type        = string
  description = "Specific the interface identifier of the assigned VLAN"
  default     = null
}

variable "firewall" {
  type        = any
  description = "All firewall rules to be applied on VLAN"
}