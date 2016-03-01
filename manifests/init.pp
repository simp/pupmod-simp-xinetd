# == Class: xinetd
#
# Set up xinetd
# This is incomplete but should suffice for basic purposes.
#
# == Parameters
#
# NOTE: Items prefixed with 'x_' were reserved words in ERB.
# * xinetd/xinetd.conf.erb
#
# Explanations of the options can be found in the xinetd.conf(5) man page.
#
# == Authors
#
# * Trevor Vaughan <tvaughan@onyxpoint.com>
#
class xinetd(
  $log_type       = 'SYSLOG authpriv',
  $x_bind         = 'nil',
  $per_source     = 'nil',
  $x_umask        = 'nil',
  $log_on_success = 'HOST PID DURATION TRAFFIC',
  $log_on_failure = 'HOST',
  $only_from      = 'nil',
  $no_access      = 'nil',
  $passenv        = 'nil',
  $instances      = '60',
  $disabled       = 'nil',
  $disable        = 'nil',
  $enabled        = 'nil',
  $banner         = '/etc/issue.net',
  $banner_success = 'nil',
  $banner_fail    = 'nil',
  $groups         = 'no',
  $cps            = '25 30',
  $max_load       = 'nil'
) {

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


  validate_string($log_type)
  if $x_bind != 'nil' { validate_string($x_bind) }
  if $per_source != 'nil' { validate_re($per_source, '(^\d+$|UNLIMITED)') }
  if $x_umask != 'nil' { validate_umask($x_umask) }
  validate_string($log_on_success)
  validate_string($log_on_failure)
  if $no_access != 'nil' { validate_string($no_access) }
  if $passenv != 'nil' { validate_array($passenv) }
  validate_re($instances, '(^\d+$|UNLIMITED)')
  if $disable != 'nil' { validate_re('(yes|no)') }
  if $disabled != 'nil' { validate_string($disabled) }
  if $enabled != 'nil' { validate_string($enabled) }
  validate_string($banner)
  if $banner_success != 'nil' { validate_string($banner_success) }
  if $banner_fail != 'nil' { validate_string($banner_fail) }
  validate_re($groups, '(yes|no)')
  validate_re($cps, '^\d+\s\d+$')
  if $max_load != 'nil' { validate_re($max_load, '^(.?|\d+).?\d*$') }

  compliance_map()
}
