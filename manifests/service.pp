# == Define xinetd::service
#
# Configure the xinetd service
#
# == Parameters
#
# For the identification of what these options should be, consult the
# xinetd.conf(5) man page.
#
# Items prefixed with 'x_' were reserved words in ERB.
# * xinetd/xinetd.service.erb
#
# == Authors
#
# Trevor Vaughan <tvaughan@onyxpoint.com>
#
define xinetd::service (
    $server,
    $port,
    $protocol,
    $x_wait,
    $socket_type,
    $disable = 'no',
    $libwrap_name = 'nil',
    $libwrap = 'nil',
    $user = 'root',
    $x_umask = '027',
    $log_type = 'SYSLOG authpriv',
    $log_on_success = 'HOST PID DURATION TRAFFIC',
    $log_on_failure = 'HOST',
    $x_id = 'nil',
    $x_type = 'nil',
    $flags = 'nil',
    $group = 'nil',
    $instances = 'nil',
    $nice = 'nil',
    $server_args = 'nil',
    $only_from = 'nil',
    $access_times = 'nil',
    $rpc_version = 'nil',
    $rpc_number = 'nil',
    $env = 'nil',
    $passenv = 'nil',
    $redirect_ip = 'nil',
    $redirect_port = 'nil',
    $x_bind = 'nil',
    $banner = 'nil',
    $banner_success = 'nil',
    $banner_fail = 'nil',
    $per_source = 'nil',
    $cps = 'nil',
    $max_load = 'nil',
    $groups = 'nil',
    $mdns = 'nil',
    $enabled = 'nil',
    $include = 'nil',
    $includedir = 'nil',
    $rlimit_as = 'nil',
    $rlimit_cpu = 'nil',
    $rlimit_data = 'nil',
    $rlimit_rss = 'nil',
    $rlimit_stack = 'nil',
    $deny_time = 'nil'
) {
  include 'rsync'

  validate_string($server)
  validate_integer($port)
  validate_string($protocol)
  validate_re($x_wait, '(yes|no)')
  validate_re($socket_type, '(stream|dgram|raw|seqpacket)')
  validate_re($disable, '(yes|no)')
  if $libwrap_name != 'nil' { validate_string($libwrap_name) }
  if $libwrap != 'nil' { validate_string($libwrap) }
  validate_string($user)
  validate_umask($x_umask)
  validate_log_type($log_type)
  validate_array_member(split($log_on_success,' '), ['PID','HOST','USERID','EXIT','DURATION','TRAFFIC'],'i')
  validate_array_member(split($log_on_failure,' '), ['HOST','USERID','ATTEMPT'],'i')
  if $x_id != 'nil' { validate_string($x_id) }
  if $x_type != 'nil' { validate_array_member(split($x_type,' '),['RPC','INTERNAL','TCPMUX/TCPMUXPLUS','UNLISTED'],'i') }
  if $flags != 'nil' { validate_array_member(split($flags,' '),['INTERCEPT','NORETRY','IDONLY','NAMEINARGS','NODELAY','KEEPALIVE','NOLIBWRAP','SENSOR','IPv4','IPv6','LABELED','REUSE'],'i') }
  if $group != 'nil' { validate_string($group) }
  if $instances != 'nil' { validate_re($instances, '(^\d+$|UNLIMITED)') }
  if $nice != 'nil' { validate_integer($nice) }
  if $access_times != 'nil' { validate_re($access_times, '^([01]?[0-9]|2[0-3]):[0-5][0-9]-([01]?[0-9]|2[0-3]):[0-5][0-9]$') }
  if $rpc_version != 'nil' { validate_re($rpc_version, '^\d+-\d+$') }
  if $rpc_number != 'nil' { validate_integer($rpc_number) }
  if $env != 'nil' { validate_string($env) }
  if $passenv != 'nil' { validate_string($passenv) }
  if ($redirect_ip != 'nil' and $redirect_port != 'nil') { validate_net_list("${redirect_ip}:${redirect_port}") }
  if $x_bind != 'nil' { validate_net_list($x_bind) }
  if $banner != 'nil' { validate_string($banner) }
  if $banner_success != 'nil' { validate_string($banner_success) }
  if $banner_fail != 'nil' { validate_string($banner_fail) }
  if $per_source != 'nil' { validate_re($per_source, '(^\d+$|UNLIMITED)') }
  if $cps != 'nil' { validate_re($cps, '^\d+\s\d+$') }
  if $max_load != 'nil' { validate_re($max_load, '^(.?|\d+).?\d*$') }
  if $groups != 'nil' { validate_re($groups, '(yes|no)') }
  if $mdns != 'nil' { validate_re($mdns, '(yes|no)') }
  if $enabled != 'nil' { validate_string($enabled) }
  if $include != 'nil' { validate_string($include) }
  if $includedir != 'nil' { validate_string($includedir) }
  if $rlimit_as != 'nil' { validate_re($rlimit_as, '^((\d+)|(UNLIMITED))$') }
  if $rlimit_cpu != 'nil' { validate_re($rlimit_cpu, '^((\d+)|(UNLIMITED))$') }
  if $rlimit_data != 'nil' { validate_re($rlimit_data, '^((\d+)|(UNLIMITED))$') }
  if $rlimit_rss != 'nil' { validate_re($rlimit_rss, '^((\d+)|(UNLIMITED))$') }
  if $rlimit_stack != 'nil' { validate_re($rlimit_stack, '^((\d+)|(UNLIMITED))$') }
  if $deny_time != 'nil' { validate_re($deny_time, '^((\d+)|(FOREVER|NEVER))$') }

  file { "/etc/xinetd.d/${name}":
    owner   => 'root',
    group   => 'root',
    mode    => '0640',
    content => template('xinetd/xinetd.service.erb'),
    notify  => Service['xinetd']
  }

  case $protocol {
    'tcp':  {
      iptables::add_tcp_stateful_listen { "allow_${name}":
        order       => '11',
        client_nets => $only_from,
        dports      => $port
      }
    }
    'udp':  {
      iptables::add_udp_listen { "allow_${name}":
        order       => '11',
        client_nets => $only_from,
        dports      => $port
      }
    }
    default:  {
    }
  }

  if defined('tcpwrappers') and defined(Class['tcpwrappers']) {
    case $libwrap_name {
      'nil':  {
        tcpwrappers::allow { $name:
          pattern => $only_from
        }
      }
      default:  {
        tcpwrappers::allow { $libwrap_name:
          pattern => $only_from
        }
      }
    }
  }
}
