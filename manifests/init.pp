# Set up xinetd
# This is incomplete but should suffice for basic purposes.
#
# NOTE: Items prefixed with 'x_' were reserved words in ERB.
# * xinetd/xinetd.conf.erb
#
# Explanations of the options can be found in the xinetd.conf(5) man page.
#
# @author Trevor Vaughan <tvaughan@onyxpoint.com>
#
class xinetd (
  String                           $log_type       = 'SYSLOG authpriv',
  Optional[String]                 $x_bind         = undef,
  Optional[Xinetd::UnlimitedInt]   $per_source     = undef,
  Optional[String]                 $x_umask        = undef,
  Array[Xinetd::SuccessLogOption]  $log_on_success = ['HOST','PID','DURATION','TRAFFIC'],
  Array[Xinetd::FailureLogOption]  $log_on_failure = ['HOST'],
  Array[String]                    $trusted_nets   = lookup('simp_options::trusted_nets', { 'default_value' => ['127.0.0.1', '::1'] }),
  Optional[Array[String]]          $no_access      = undef,
  Optional[String]                 $passenv        = undef,
  Xinetd::UnlimitedInt             $instances      = '60',
  Optional[Array[String]]          $disabled       = undef,
  Optional[Enum['yes','no']]       $disable        = undef,
  Optional[Array[String]]          $enabled        = undef,
  Stdlib::Absolutepath             $banner         = '/etc/issue.net',
  Optional[Stdlib::Absolutepath]   $banner_success = undef,
  Optional[Stdlib::Absolutepath]   $banner_fail    = undef,
  Enum['yes','no']                 $groups         = 'no',
  Tuple[Integer,Integer]           $cps            = [25,30],
  Optional[Float]                  $max_load       = undef
) {

  #TODO Fix the inconsistent use of strings versus arrays.  Some of these
  # config items are strings that contain a space-separated list of items.
  validate_log_type($log_type)
  if $x_bind  { validate_net_list($x_bind) }
  if $x_umask { validate_umask($x_umask) }
  if $no_access { validate_net_list($no_access) }

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
    require => Package['xinetd']
  }

  package { 'xinetd': ensure => 'latest' }

  service { 'xinetd':
    ensure    => 'running',
    enable    => true,
    hasstatus => true,
    restart   => '( /bin/ps -C xinetd && /sbin/service xinetd reload ) || /sbin/service xinetd start',
    require   => Package['xinetd']
  }

}
