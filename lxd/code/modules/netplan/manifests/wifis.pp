# @summary validates wifi config and writes it to $config_file via concat
#
# @api private
#
# @note intended to be used only by netplan class
#
# @param match
#  This selects a subset of available physical devices by various hardware properties.
#  The following configuration will then apply to all matching devices, as soon as they appear.
#  All specified properties must match.
#  name: Current interface name. Globs are supported, and the primary use case for matching on names,
#    as selecting one fixed name can be more easily achieved with having no match: at all and just using
#    the ID (see above). Note that currently only networkd supports globbing, NetworkManager does not.
#  macaddress: Device’s MAC address in the form "XX:XX:XX:XX:XX:XX". Globs are not allowed.
#  driver: Kernel driver name, corresponding to the DRIVER udev property. Globs are supported.
#    Matching on driver is only supported with networkd.
# @param set_name
#  When matching on unique properties such as path or MAC, or with additional assumptions such as
#  "there will only ever be one wifi device", match rules can be written so that they only match one device.
#  Then this property can be used to give that device a more specific/desirable/nicer name than the default
#  from udev’s ifnames. Any additional device that satisfies the match rules will then fail to get renamed
#  and keep the original kernel name (and dmesg will show an error).
# @param wakeonlan
#  Enable wake on LAN. Off by default.
#
# @param renderer
#  Use the given networking backend for this definition. Currently supported are networkd and NetworkManager.
#  This property can be specified globally in networks:, for a device type (in e. g. ethernets:) or for a
#  particular device definition. Default is networkd.
# @param dhcp4
#  Enable DHCP for IPv4. Off by default.
# @param dhcp6
#  Enable DHCP for IPv6. Off by default.
# @param ipv6_privacy
#  Enable IPv6 Privacy Extensions. Off by default.
# @param link_local
#  Configure the link-local addresses to bring up. Valid options are ‘ipv4’ and ‘ipv6’.
# @param critical
#  (networkd backend only) Designate the connection as "critical to the system", meaning that special
#  care will be taken by systemd-networkd to not release the IP from DHCP when the daemon is restarted.
# @param dhcp_identifier
#  When set to ‘mac’; pass that setting over to systemd-networkd to use the device’s MAC address as a
#  unique identifier rather than a RFC4361-compliant Client ID. This has no effect when NetworkManager
#  is used as a renderer.
# @param dhcp4_overrides
#  (networkd backend only) Overrides default DHCP behavior
# @param dhcp6_overrides
#  (networkd backend only) Overrides default DHCP behavior
# @param accept_ra
#  Accept Router Advertisement that would have the kernel configure IPv6 by itself. On by default.
# @param addresses
#  Add static addresses to the interface in addition to the ones received through DHCP or RA.
#  Each sequence entry is in CIDR notation, i. e. of the form addr/prefixlen. addr is an IPv4 or IPv6
#  address as recognized by inet_pton(3) and prefixlen the number of bits of the subnet.
# @param gateway4
#  Set default gateway for IPv4, for manual address configuration. This requires setting addresses too.
# @param gateway6
#  Set default gateway for IPv6, for manual address configuration. This requires setting addresses too.
# @param nameservers
#  Set DNS servers and search domains, for manual address configuration. There are two supported fields:
#  addresses: is a list of IPv4 or IPv6 addresses similar to gateway*, and
#  search: is a list of search domains.
# @param macaddress
#  Set the device’s MAC address. The MAC address must be in the form "XX:XX:XX:XX:XX:XX".
# @param mtu
#  Set the Maximum Transmission Unit for the interface. The default is 1500. Valid values depend on your network interface.
# @param optional
#  An optional device is not required for booting. Normally, networkd will wait some time for device to
#  become configured before proceeding with booting. However, if a device is marked as optional, networkd
#  will not wait for it. This is only supported by networkd, and the default is false.
# @param optional_addresses
#  Specify types of addresses that are not required for a device to be considered online.
# @param routes
#  Configure static routing for the device.
#  from: Set a source IP address for traffic going through the route.
#  to: Destination address for the route.
#  via: Address to the gateway to use for this route.
#  on-link: When set to "true", specifies that the route is directly connected to the interface.
#  metric: The relative priority of the route. Must be a positive integer value.
#  type: The type of route. Valid options are “unicast" (default), “unreachable", “blackhole" or “prohibited".
#  scope: The route scope, how wide-ranging it is to the network. Possible values are “global", “link", or “host".
#  table: The table number to use for the route.
# @param routing_policy
#  The routing-policy block defines extra routing policy for a network, where traffic may be handled specially
#  based on the source IP, firewall marking, etc.
#  For from, to, both IPv4 and IPv6 addresses are recognized, and must be in the form addr/prefixlen or addr
#  from: Set a source IP address to match traffic for this policy rule.
#  to: Match on traffic going to the specified destination.
#  table: The table number to match for the route.
#  priority: Specify a priority for the routing policy rule, to influence the order in which routing rules are
#    processed. A higher number means lower priority: rules are processed in order by increasing priority number.
#  mark: Have this routing policy rule match on traffic that has been marked by the iptables firewall with
#    this value. Allowed values are positive integers starting from 1.
#  type_of_service: Match this policy rule based on the type of service number applied to the traffic.
#
# @param access-points
#  This provides pre-configured connections to NetworkManager. Note that users can of course select other 
#  access points/SSIDs. The keys of the mapping are the SSIDs, and the values are mappings with the following 
#  supported properties:
#  password: Enable WPA2 authentication and set the passphrase for it. If not given, the network is 
#    assumed to be open. Other authentication modes are not currently supported.
#  mode: Possible access point modes are infrastructure (the default), ap (create an access point to which 
#    other devices can connect), and adhoc (peer to peer networks without a central access point). 
#    ap is only supported with NetworkManager.
#  auth: 
#    key_management: he supported key management modes are none (no key management); psk (WPA with 
#      pre-shared key, common for home wifi); eap (WPA with EAP, common for enterprise wifi); 
#      and 802.1x (used primarily for wired Ethernet connections).
#    password: The password string for EAP, or the pre-shared key for WPA-PSK.
#    method: The EAP method to use. The supported EAP methods are tls (TLS), peap (Protected EAP), 
#      and ttls (Tunneled TLS).
#    identity: The identity to use for EAP.
#    anonymous_identity: The identity to pass over the unencrypted channel if the chosen EAP method 
#      supports passing a different tunnelled identity.
#    ca_certificate: Path to a file with one or more trusted certificate authority (CA) certificates.
#    client_certificate: Path to a file containing the certificate to be used by the client during authentication.
#    client_key: Path to a file containing the private key corresponding to client-certificate.
#    client_key_password: Password to use to decrypt the private key specified in client-key if it is encrypted.
#
define netplan::wifis (

  # common properties for physical devices
  Optional[Struct[{
    Optional['name']             => String,
    Optional['macaddress']       => Stdlib::MAC,
    Optional['driver']           => String,
  }]]                                                             $match = undef,
  Optional[String]                                                $set_name = undef,
  Optional[Boolean]                                               $wakeonlan = undef,

  # common properties
  Optional[Enum['networkd', 'NetworkManager']]                    $renderer = undef,
  #lint:ignore:quoted_booleans
  Optional[Variant[Enum['true', 'false', 'yes', 'no'], Boolean]]  $dhcp4 = undef,
  Optional[Variant[Enum['true', 'false', 'yes', 'no'], Boolean]]  $dhcp6 = undef,
  #lint:endignore
  Optional[Boolean]                                               $ipv6_privacy = undef,
  Optional[Tuple[Enum['ipv4', 'ipv6'], 0]]                        $link_local = undef,
  Optional[Boolean]                                               $critical = undef,
  Optional[Enum['mac']]                                           $dhcp_identifier = undef,
  Optional[Struct[{
    Optional['use_dns']         => Boolean,
    Optional['use_ntp']         => Boolean,
    Optional['send_hostname']   => Boolean,
    Optional['use_hostname']    => Boolean,
    Optional['use_mtu']         => Boolean,
    Optional['hostname']        => Stdlib::Fqdn,
    Optional['use_routes']      => Boolean,
    Optional['route_metric']    => Integer,
  }]]                                                             $dhcp4_overrides = undef,
  Optional[Struct[{
    Optional['use_dns']         => Boolean,
    Optional['use_ntp']         => Boolean,
    Optional['send_hostname']   => Boolean,
    Optional['use_hostname']    => Boolean,
    Optional['use_mtu']         => Boolean,
    Optional['hostname']        => Stdlib::Fqdn,
    Optional['use_routes']      => Boolean,
    Optional['route_metric']    => Integer,
  }]]                                                             $dhcp6_overrides = undef,
  Optional[Boolean]                                               $accept_ra = undef,
  Optional[Array[Stdlib::IP::Address]]                            $addresses = undef,
  Optional[Stdlib::IP::Address::V4::Nosubnet]                     $gateway4 = undef,
  Optional[Stdlib::IP::Address::V6::Nosubnet]                     $gateway6 = undef,
  Optional[Struct[{
    Optional['search']          => Array[Stdlib::Fqdn],    
    'addresses'                 => Array[Stdlib::IP::Address]
  }]]                                                             $nameservers = undef,
  Optional[Stdlib::MAC]                                           $macaddress = undef,
  Optional[Integer]                                               $mtu = undef,
  Optional[Boolean]                                               $optional = undef,
  Optional[Array[String]]                                         $optional_addresses = undef,
  Optional[Array[Struct[{
    Optional['from']            => Stdlib::IP::Address,
    'to'                        => Variant[Stdlib::IP::Address, Enum['0.0.0.0/0', '::/0']],
    'via'                       => Stdlib::IP::Address::Nosubnet,
    Optional['on_link']         => Boolean,
    Optional['metric']          => Integer,
    Optional['type']            => Enum['unicast', 'unreachable', 'blackhole', 'prohibited'],
    Optional['scope']           => Enum['global', 'link', 'host'],
    Optional['table']           => Integer,
  }]]]                                                            $routes = undef,
  Optional[Array[Struct[{
    'from'                      => Stdlib::IP::Address,
    'to'                        => Variant[Stdlib::IP::Address, Enum['0.0.0.0/0', '::/0']],
    Optional['table']           => Integer,
    Optional['priority']        => Integer,
    Optional['mark']            => Integer,
    Optional['type_of_service'] => Integer,
  }]]]                                                            $routing_policy = undef,

  # wifis specific properties
  Optional[Hash[String, Struct[{
    Optional['password']        => String,
    Optional['mode']            => Enum['infrastructure', 'ap', 'adhoc'],
    Optional['auth']            => Struct[{
      Optional['key_management']      => Enum['none', 'psk', 'eap', '802.1x'],
      Optional['password']            => String,
      Optional['method']              => Enum['tls', 'peap', 'ttls'],
      Optional['identity']            => String,
      Optional['anonymous_identity']  => String,
      Optional['ca_certificate']      => String,
      Optional['client_certificate']  => String,
      Optional['client_key']          => String,
      Optional['client_key_password'] => String,
    }]
  }]]]                                                            $access_points = undef,

  ){

  $_dhcp4 = $dhcp4 ? {
    true    => true,
    'yes'   => true,
    false   => false,
    'no'    => false,
    default => undef,
  }

  $_dhcp6 = $dhcp6 ? {
    true    => true,
    'yes'   => true,
    false   => false,
    'no'    => false,
    default => undef,
  }

  $wifistmp = epp("${module_name}/wifis.epp", {
    'name'               => $name,
    'match'              => $match,
    'set_name'           => $set_name,
    'wakeonlan'          => $wakeonlan,
    'renderer'           => $renderer,
    'dhcp4'              => $_dhcp4,
    'dhcp6'              => $_dhcp6,
    'ipv6_privacy'       => $ipv6_privacy,
    'link_local'         => $link_local,
    'critical'           => $critical,
    'dhcp_identifier'    => $dhcp_identifier,
    'dhcp4_overrides'    => $dhcp4_overrides,
    'dhcp6_overrides'    => $dhcp6_overrides,
    'accept_ra'          => $accept_ra,
    'addresses'          => $addresses,
    'gateway4'           => $gateway4,
    'gateway6'           => $gateway6,
    'nameservers'        => $nameservers,
    'macaddress'         => $macaddress,
    'mtu'                => $mtu,
    'optional'           => $optional,
    'optional_addresses' => $optional_addresses,
    'routes'             => $routes,
    'routing_policy'     => $routing_policy,
    'access_points'      => $access_points,
  })

  concat::fragment { $name:
    target  => $netplan::config_file,
    content => $wifistmp,
    order   => '31',
  }

}
