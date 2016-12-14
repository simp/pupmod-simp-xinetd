# Configure the xinetd service
#
# For the identification of what these options should be, consult the
# xinetd.conf(5) man page.
#
# Items prefixed with 'x_' were reserved words in ERB.
# * xinetd/xinetd.service.erb
#
# @author Trevor Vaughan <tvaughan@onyxpoint.com>
#
define xinetd::service (
  String                            $server,
  Integer                           $port,
  String                            $protocol,
  Enum['yes','no']                  $x_wait,
  Xinetd::SocketType                $socket_type,
  Enum['yes','no']                  $disable        = 'no',
  Optional[String]                  $libwrap_name   = undef,
  Optional[String]                  $libwrap        = undef,
  String                            $user           = 'root',
  String                            $x_umask        = '027',
  String                            $log_type       = 'SYSLOG authpriv',
  Array[Xinetd::SuccessLogOption]   $log_on_success = ['HOST','PID','DURATION','TRAFFIC'],
  Array[Xinetd::FailureLogOption]   $log_on_failure = ['HOST'],
  Optional[String]                  $x_id           = undef,
  Optional[Xinetd::Type]            $x_type         = undef,
  Optional[Array[Xinetd::Flags]]    $flags          = undef,
  Optional[String]                  $group          = undef,
  Optional[Xinetd::UnlimitedInt]    $instances      = undef,
  Optional[Integer]                 $nice           = undef,
  Optional[String]                  $server_args    = undef,
  Array                             $trusted_nets   = simplib::lookup('::simp_options::trusted_nets', { 'default_value' => ['127.0.0.1', '::1'] }),
  Optional[Xinetd::AccessTimes]     $access_times   = undef,
  Optional[Xinetd::RpcVersion]      $rpc_version    = undef,
  Optional[Integer]                 $rpc_number     = undef,
  Optional[String]                  $env            = undef,
  Optional[String]                  $passenv        = undef,
  Optional[String]                  $redirect_ip    = undef,
  Optional[Integer]                 $redirect_port  = undef,
  Optional[String]                  $x_bind         = undef,
  Optional[Stdlib::Absolutepath]    $banner         = undef,
  Optional[Stdlib::Absolutepath]    $banner_success = undef,
  Optional[Stdlib::Absolutepath]    $banner_fail    = undef,
  Optional[Xinetd::UnlimitedInt]    $per_source     = undef,
  Optional[Tuple[Integer,Integer]]  $cps            = undef,
  Optional[Float]                   $max_load       = undef,
  Optional[Enum['yes','no']]        $groups         = undef,
  Optional[Enum['yes','no']]        $mdns           = undef,
  Optional[Array[String]]           $enabled        = undef,
  Optional[Stdlib::Absolutepath]    $include        = undef,
  Optional[Stdlib::Absolutepath]    $includedir     = undef,
  Optional[Xinetd::UnlimitedInt]    $rlimit_as      = undef,
  Optional[Xinetd::UnlimitedInt]    $rlimit_cpu     = undef,
  Optional[Xinetd::UnlimitedInt]    $rlimit_data    = undef,
  Optional[Xinetd::UnlimitedInt]    $rlimit_rss     = undef,
  Optional[Xinetd::UnlimitedInt]    $rlimit_stack   = undef,
  Optional[Xinetd::DenyTime]        $deny_time      = undef,
  Boolean                           $firewall       = simplib::lookup('::simp_options::firewall', { 'default_value' => false }),
  Boolean                           $tcpwrappers    = simplib::lookup('::simp_options::tcpwrappers', { 'default_value' => false })
) {
  validate_port($port)
  validate_umask($x_umask)
  validate_log_type($log_type)
  if ($redirect_ip and $redirect_port) { validate_net_list("${redirect_ip}:${redirect_port}") }
  if $x_bind                           { validate_net_list($x_bind) }

  include '::xinetd'

  file { "/etc/xinetd.d/${name}":
    owner   => 'root',
    group   => 'root',
    mode    => '0640',
    content => template('xinetd/xinetd.service.erb'),
    notify  => Service['xinetd']
  }

  if $firewall {
    include '::iptables'
    case $protocol {
      'tcp':  {
        iptables::add_tcp_stateful_listen { "allow_${name}":
          order        => '11',
          trusted_nets => $trusted_nets,
          dports       => $port
        }
      }
      'udp':  {
        iptables::add_udp_listen { "allow_${name}":
          order        => '11',
          trusted_nets => $trusted_nets,
          dports       => $port
        }
      }
      default:  {
      }
    }
  }

  if $tcpwrappers {
    include '::tcpwrappers'
    if $libwrap_name {
      tcpwrappers::allow { $libwrap_name:
        pattern => $trusted_nets
      }
    }
    else  {
      tcpwrappers::allow { $name:
        pattern => $trusted_nets
      }
    }
  }

}
