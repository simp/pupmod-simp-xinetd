define xinetd::firewall::xinetd_service (
  $protocol,
  $port,
  $only_from = 'nil'
) {
  include 'xinetd::config::xinetd_service'

  validate_string($protocol)
  validate_integer($port)

  case $protocol or hiera('protocol') {
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
    default:  {
    }
  }

}

