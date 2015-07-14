# == Define xinetd::config::xinetd_service
#
# Configure the xinetd service
# xinetd::config::xinetd_service service refers to an xinetd-managed service, not the xinetd ::service itself.
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
# Trevor Vaughan <mailto:tvaughan@onyxpoint.com>
# Nick Miller <mailto:nick.miller@onyxpoint.com>
#
define xinetd::config::xinetd_service (
    $server,
    $port,
    $protocol,
    $x_wait,
    $socket_type,
    $disable        = 'no',
    $libwrap_name   = '',
    $libwrap        = '',
    $user           = 'root',
    $x_umask        = '027',
    $log_type       = 'SYSLOG authpriv',
    $log_on_success = 'HOST PID DURATION TRAFFIC',
    $log_on_failure = 'HOST',
    $x_id           = '',
    $x_type         = '',
    $flags          = '',
    $group          = '',
    $instances      = '',
    $nice           = '',
    $server_args    = '',
    $only_from      = '',
    $access_times   = '',
    $rpc_version    = '',
    $rpc_number     = '',
    $env            = '',
    $passenv        = '',
    $redirect_ip    = '',
    $redirect_port  = '',
    $x_bind         = '',
    $banner         = '',
    $banner_success = '',
    $banner_fail    = '',
    $per_source     = '',
    $cps            = '',
    $max_load       = '',
    $groups         = '',
    $mdns           = '',
    $enabled        = '',
    $include        = '',
    $includedir     = '',
    $rlimit_as      = '',
    $rlimit_cpu     = '',
    $rlimit_data    = '',
    $rlimit_rss     = '',
    $rlimit_stack   = '',
    $deny_time      = ''
) {
  # include 'rsync'
  include '::xinetd'

  validate_string($server)
  validate_integer($port)
  validate_string($protocol)
  validate_re($x_wait, '(yes|no)')
  validate_re($socket_type, '(stream|dgram|raw|seqpacket)')
  validate_re($disable, '(yes|no)')
  if !empty($libwrap_name) { validate_string($libwrap_name) }
  if !empty($libwrap) { validate_string($libwrap) }
  validate_string($user)
  validate_umask($x_umask)
  validate_xinetd_log_type($log_type)
  validate_array_member(split($log_on_success,' '), ['PID','HOST','USERID','EXIT','DURATION','TRAFFIC'],'i')
  validate_array_member(split($log_on_failure,' '), ['HOST','USERID','ATTEMPT'],'i')
  if !empty($x_id) { validate_string($x_id) }
  if !empty($x_type) { validate_array_member(split($x_type,' '),['RPC','INTERNAL','TCPMUX/TCPMUXPLUS','UNLISTED'],'i') }
  if !empty($flags) { validate_array_member(split($flags,' '),['INTERCEPT','NORETRY','IDONLY','NAMEINARGS','NODELAY','KEEPALIVE','NOLIBWRAP','SENSOR','IPv4','IPv6','LABELED','REUSE'],'i') }
  if !empty($group) { validate_string($group) }
  if !empty($instances) { validate_re($instances, '(^\d+$|UNLIMITED)') }
  if !empty($nice) { validate_integer($nice) }
  if !empty($access_times) { validate_re($access_times, '^([01]?[0-9]|2[0-3]):[0-5][0-9]-([01]?[0-9]|2[0-3]):[0-5][0-9]$') }
  if !empty($rpc_version) { validate_re($rpc_version, '^\d+-\d+$') }
  if !empty($rpc_number) { validate_integer($rpc_number) }
  if !empty($env) { validate_string($env) }
  if !empty($passenv) { validate_string($passenv) }
  if !empty($redirect_ip) and !empty($redirect_port) { validate_net_list("$redirect_ip:redirect_port") }
  if !empty($x_bind) { validate_net_list($x_bind) }
  if !empty($banner) { validate_string($banner) }
  if !empty($banner_success) { validate_string($banner_success) }
  if !empty($banner_fail) { validate_string($banner_fail) }
  if !empty($per_source) { validate_re($per_source, '(^\d+$|UNLIMITED)') }
  if !empty($cps) { validate_re($cps, '^\d+\s\d+$') }
  if !empty($max_load) { validate_re($max_load, '^(.?|\d+).?\d*$') }
  if !empty($groups) { validate_re($groups, '(yes|no)') }
  if !empty($mdns) { validate_re($mdns, '(yes|no)') }
  if !empty($enabled) { validate_string($enabled) }
  if !empty($include) { validate_string($include) }
  if !empty($includedir) { validate_string($includedir) }
  if !empty($rlimit_as) { validate_re($rlimit_as, '^((\d+)|(UNLIMITED))$') }
  if !empty($rlimit_cpu) { validate_re($rlimit_cpu, '^((\d+)|(UNLIMITED))$') }
  if !empty($rlimit_data) { validate_re($rlimit_data, '^((\d+)|(UNLIMITED))$') }
  if !empty($rlimit_rss) { validate_re($rlimit_rss, '^((\d+)|(UNLIMITED))$') }
  if !empty($rlimit_stack) { validate_re($rlimit_stack, '^((\d+)|(UNLIMITED))$') }
  if !empty($deny_time) { validate_re($deny_time, '^((\d+)|(FOREVER|NEVER))$') }

  file { "/etc/xinetd.d/$name":
    owner   => 'root',
    group   => 'root',
    mode    => '0640',
    content => template('xinetd/xinetd.service.erb'),
    notify  => Service['xinetd']
  }

  if $::use_simp_firewall {
    xinetd::firewall::xinetd_service { '$name':
      protocol  => $protocol,
      only_from => $only_from,
      port      => $port
    }
  }

  if $::enable_tcpwrappers {
    xinetd::tcpwrappers::xinetd_service { '$name':
      only_from    => $only_from,
      libwrap_name => $libwrap_name
    }
  }

}
