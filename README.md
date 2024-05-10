Opnsense has a limited API. os-firewall plugin must be installed.

Always first setup the VLAN's, there are dependency issues that are not enforced you'll otherwise run into.

For each new VLAN creation, you need to do the following manually (for now):

* Assign the newly created interface at /interfaces_assign.php
* Go to the interface itself, that is now present in the submenu, and do the following:
  * Check enable
  * Set static IPv4 to 192.168.TAG.1 (or whatever to your liking)
  * Ensure you've set it at /24, as default is /32!
  * Apply changes
  * Add the interface identifier to the vlan configuration yaml, if not set - firewall rules will not be able to be set.
* Go to services -> DHCPv4 -> VLAN interface, and do the following:
  * Check enable
  * Set the range (e.g. 192.168.TAG.1-192.168.TAG.254)
    * If you're unable to set it, you most likely left static config at /32

Beware that if you want no Tagged VLAN Management in a Port Profile in Unifi - but with a native vlan set, you need to set this manually in the UI after creation -> and you must set forward to native. Not sure where the issue lays nor do I want to figure it out for now, could be API or the Terraform provider.

For each new VLAN deletion, you need to do the following manually (for now):

* Manually remove all interface assignments associated with the VLAN in OPNsense