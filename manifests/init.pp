# == Class: xinetd
#
# Set up xinetd
# This is incomplete but should suffice for basic purposes.
#
# == Parameters
#
# TODO: compelete
# NOTE: Items prefixed with 'x_' were reserved words in ERB.
# * xinetd/xinetd.conf.erb
#
# Explanations of the options can be found in the xinetd.conf(5) man page.
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
