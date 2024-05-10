terraform {
  required_providers {
    opnsense = {
      version = ">= 0.10.1"
      source  = "browningluke/opnsense"
    }
    bitwarden = {
      source  = "maxlaverse/bitwarden"
      version = ">= 0.8.0"
    }
    unifi = {
      source  = "paultyng/unifi"
      version = ">= 0.41.0"
    }
  }
}