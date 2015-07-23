# == Define xinetd::firewall::xinetd_service
#
# Configure an xinetd service
# xinetd::firewall::xinetd_service service refers to an xinetd-managed service,
# not the xinetd ::service itself.
#
# == Parameters
#
# For the identification of what these options should be, consult the
# xinetd.conf(5) man page.
#
# == Authors
#
# Trevor Vaughan <mailto:tvaughan@onyxpoint.com>
# Nick Miller <mailto:nick.miller@onyxpoint.com>
#
define xinetd::firewall::xinetd_service (
  $protocol,
  $port,
  $only_from = 'nil',
  $libwrap_name = 'nil'
) {
  include '::xinetd'

  validate_re($protocol, ['tcp', 'udp'])
  validate_integer($port)

  case $protocol {
    'tcp':  {
      iptables::add_tcp_stateful_listen { "allow_$name":
        order       => '11',
        client_nets => $only_from,
        dports      => $port
      }
    }
    'udp':  {
      iptables::add_udp_listen { "allow_$name":
        order       => '11',
        client_nets => $only_from,
        dports      => $port
      }
    }
    # This case should never be reached because of the validation above
    # It is here to satisfy puppet-lint
    default:  {
      notify { 'error': message => 'Protocol was not of a supported type!' }
    }
  }

}
