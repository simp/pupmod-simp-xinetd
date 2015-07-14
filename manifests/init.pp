# == Class: xinetd
#
# Manages the xinetd package, configuration, and services.
#
# == Parameters
#
# [*use_simp_firewall*]
# Type: Boolean
# Default: false
#   If true, the xinetd module will write firewall rules using the SIMP
#   iptables module and iptables. If set to false, this module will not
#   write any firewall rules.
#
# [*enable_tcpwrappers*]
# Type: Boolean
# Default: false
#   If true, the module will configure tcpwrappers(tcpd) with xinetd
#   services created by the module.
#
# == Authors
#
# * Trevor Vaughan <mailto:tvaughan@onyxpoint.com>
# * Nick Miller <mailto:nick.miller@onyxpoint.com>
#
class xinetd (
  $service_name = $::xinetd::params::service_name,
  $package_name = $::xinetd::params::package_name,

  $use_simp_firewall = defined('$::use_simp_firewall') ? { true => $::use_simp_firewall, default => hiera('use_simp_firewall',false) },
  $enable_tcpwrappers  = defined('$::enable_tcpwrappers')  ? { true => $::enable_tcpwrappers,  default => hiera('enable_tcpwrappers',false) }

  ) inherits ::xinetd::params {

  validate_string( $service_name )
  validate_string( $package_name )
  validate_bool( $use_simp_firewall )
  validate_bool( $enable_tcpwrappers )

  include '::xinetd::install'
  include '::xinetd::config'
  include '::xinetd::service'

  Class[ '::xinetd::install' ] ->
  Class[ '::xinetd::config'  ] ~>
  Class[ '::xinetd::service' ] ->
  Class[ '::xinetd' ]

}
