# @summary Set up xinetd
# This is incomplete but should suffice for most purposes.
#
# NOTE: Items prefixed with 'x_' were reserved words in ERB.
# * xinetd/xinetd.conf.erb
#
# Explanations of the options can be found in the xinetd.conf(5) man page.
#
# @param log_type
# @param x_bind
# @param per_source
# @param x_umask
# @param log_on_success
# @param log_on_failure
# @param trusted_nets
# @param no_access
# @param passenv
# @param instances
# @param disabled
# @param disable
# @param enabled
# @param banner
# @param banner_success
# @param banner_fail
# @param groups
# @param cps
# @param max_load
#
# @param purge
#   Purge all unmanaged services
#
# @param package_ensure
#   The ``package`` resource ensure to apply to all included package resources
#
# @author https://github.com/simp/pupmod-simp-xinetd/graphs/contributors
#
class xinetd (
  String[1]                       $log_type       = 'SYSLOG authpriv',
  Optional[String[1]]             $x_bind         = undef,
  Optional[Xinetd::UnlimitedInt]  $per_source     = undef,
  Optional[Simplib::Umask]        $x_umask        = undef,
  Array[Xinetd::SuccessLogOption] $log_on_success = ['HOST','PID','DURATION'],
  Array[Xinetd::FailureLogOption] $log_on_failure = ['HOST'],
  Simplib::Netlist                $trusted_nets   = lookup('simp_options::trusted_nets', { 'default_value' => ['127.0.0.1', '::1'] }),
  Optional[Array[String[1]]]      $no_access      = undef,
  Optional[String[1]]             $passenv        = undef,
  Xinetd::UnlimitedInt            $instances      = '60',
  Optional[Array[String[1]]]      $disabled       = undef,
  Optional[Enum['yes','no']]      $disable        = undef,
  Optional[Array[String[1]]]      $enabled        = undef,
  Stdlib::Absolutepath            $banner         = '/etc/issue.net',
  Optional[Stdlib::Absolutepath]  $banner_success = undef,
  Optional[Stdlib::Absolutepath]  $banner_fail    = undef,
  Enum['yes','no']                $groups         = 'no',
  Tuple[Integer[1],Integer[1]]    $cps            = [25,30],
  Optional[Float[0]]              $max_load       = undef,
  Boolean                         $purge          = false,
  String[1]                       $package_ensure = simplib::lookup('simp_options::package_ensure', { 'default_value' => 'installed' }),
) {

  #TODO Fix the inconsistent use of strings versus arrays.  Some of these
  # config items are strings that contain a space-separated list of items.
  xinetd::validate_log_type($log_type)
  if $x_bind  { simplib::validate_net_list($x_bind) }
  if $no_access { simplib::validate_net_list($no_access) }

  $_only_from = simplib::nets2cidr($trusted_nets)

  file { '/etc/xinetd.conf':
    owner   => 'root',
    group   => 'root',
    mode    => '0600',
    content => template('xinetd/xinetd.conf.erb'),
    notify  => [ Service['xinetd'] ],
    require => Package['xinetd']
  }

  file { '/etc/xinetd.d':
    ensure  => 'directory',
    owner   => 'root',
    group   => 'root',
    mode    => '0640',
    recurse => true,
    purge   => $purge,
    require => Package['xinetd']
  }

  package { 'xinetd':
    ensure => $package_ensure
  }

  service { 'xinetd':
    ensure    => 'running',
    enable    => true,
    hasstatus => true,
    restart   => '( /bin/ps -C xinetd && /sbin/service xinetd reload ) || /sbin/service xinetd start',
    require   => Package['xinetd']
  }
}
