# @summary Configure the xinetd service
#
# For the identification of what these options should be, consult the
# xinetd.conf(5) man page.
#
# Items prefixed with 'x_' were reserved words in ERB.
# * xinetd/xinetd.service.erb
#
# @param server
# @param port
# @param protocol
# @param x_wait
# @param socket_type
# @param disable
# @param libwrap_name
# @param libwrap
# @param user
# @param x_umask
# @param log_type
# @param log_on_success
# @param log_on_failure
# @param x_id
# @param x_type
# @param flags
# @param group
# @param instances
# @param nice
# @param server_args
# @param trusted_nets
# @param access_times
# @param rpc_version
# @param rpc_number
# @param env
# @param passenv
# @param redirect_ip
# @param redirect_port
# @param x_bind
# @param banner
# @param banner_success
# @param banner_fail
# @param per_source
# @param cps
# @param max_load
# @param groups
# @param mdns
# @param enabled
# @param include
# @param includedir
# @param rlimit_as
# @param rlimit_cpu
# @param rlimit_data
# @param rlimit_rss
# @param rlimit_stack
# @param deny_time
# @param firewall
#   Enable the SIMP firewall module functionality
#
# @param tcpwrappers
#   Enable the SIMP tcpwrappers module functionality
#
# @author https://github.com/simp/pupmod-simp-xinetd/graphs/contributors
#
define xinetd::service (
  String                            $server,
  Simplib::Port                     $port,
  String                            $protocol,
  Enum['yes','no']                  $x_wait,
  Xinetd::SocketType                $socket_type,
  Enum['yes','no']                  $disable        = 'no',
  Optional[String]                  $libwrap_name   = undef,
  Optional[String]                  $libwrap        = undef,
  String                            $user           = 'root',
  Simplib::Umask                    $x_umask        = '027',
  String                            $log_type       = 'SYSLOG authpriv',
  Array[Xinetd::SuccessLogOption]   $log_on_success = ['HOST','PID','DURATION'],
  Array[Xinetd::FailureLogOption]   $log_on_failure = ['HOST'],
  Optional[String]                  $x_id           = undef,
  Optional[Xinetd::Type]            $x_type         = undef,
  Optional[Array[Xinetd::Flags]]    $flags          = undef,
  Optional[String]                  $group          = undef,
  Optional[Xinetd::UnlimitedInt]    $instances      = undef,
  Optional[Integer]                 $nice           = undef,
  Optional[String]                  $server_args    = undef,
  Simplib::Netlist                  $trusted_nets   = simplib::lookup('simp_options::trusted_nets', { 'default_value' => ['127.0.0.1', '::1'] }),
  Optional[Xinetd::AccessTimes]     $access_times   = undef,
  Optional[Xinetd::RpcVersion]      $rpc_version    = undef,
  Optional[Integer]                 $rpc_number     = undef,
  Optional[String]                  $env            = undef,
  Optional[String]                  $passenv        = undef,
  Optional[Simplib::IP]             $redirect_ip    = undef,
  Optional[Simplib::Port]           $redirect_port  = undef,
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
  Boolean                           $firewall       = simplib::lookup('simp_options::firewall', { 'default_value' => false }),
  Boolean                           $tcpwrappers    = simplib::lookup('simp_options::tcpwrappers', { 'default_value' => false })
) {
  include 'xinetd'

  unless $xinetd::package_ensure == 'absent' {

    xinetd::validate_log_type($log_type)

    if ($redirect_ip and $redirect_port) { simplib::validate_net_list("${redirect_ip}:${redirect_port}") }
    if $x_bind                           { simplib::validate_net_list($x_bind) }

    $_only_from = simplib::nets2cidr($trusted_nets)

    file { "/etc/xinetd.d/${name}":
      owner   => 'root',
      group   => 'root',
      mode    => '0640',
      content => template('xinetd/xinetd.service.erb'),
      notify  => Service['xinetd']
    }

    if $firewall {
      simplib::assert_optional_dependency($module_name, 'simp/iptables')

      include 'iptables'
      case $protocol {
        'tcp':  {
          iptables::listen::tcp_stateful { "allow_${name}":
            order        => 11,
            trusted_nets => $trusted_nets,
            dports       => $port
          }
        }
        'udp':  {
          iptables::listen::udp { "allow_${name}":
            order        => 11,
            trusted_nets => $trusted_nets,
            dports       => $port
          }
        }
        default:  {
        }
      }
    }

    if $tcpwrappers {
      simplib::assert_optional_dependency($module_name, 'simp/tcpwrappers')

      include 'tcpwrappers'

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
}
