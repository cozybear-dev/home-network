terraform {
  required_providers {
    opnsense = {
      version = ">= 0.10.1"
      source  = "browningluke/opnsense"
    }
    unifi = {
      source  = "paultyng/unifi"
      version = ">= 0.41.0"
    }
  }
}