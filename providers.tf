provider "unifi" {
  allow_insecure = true
}
provider "opnsense" {
  allow_insecure = true
}

provider "bitwarden" {
  email      = "matthijs@shadowbrokers.eu"
  vault_path = "/home/matthijs/.config/Bitwarden CLI/"
}