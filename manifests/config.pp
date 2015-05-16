# == Class xinetd::config
#
# This class is called from xinetd for service config.
#
# == Authors
#
# * Trevor Vaughan <mailto:tvaughan@onyxpoint.com>
# * Nick Miller <mailto:nick.miller@onyxpoint.com>
#

# TODO move params  and validation to ::params
class xinetd::config (
  $log_type       = 'SYSLOG authpriv',
  $x_bind         = '',
  $per_source     = '',
  $x_umask        = '',
  $log_on_success = 'HOST PID DURATION TRAFFIC',
  $log_on_failure = 'HOST',
  $only_from      = '',
  $no_access      = '',
  $passenv        = '',
  $instances      = '60',
  $disabled       = '',
  $disable        = '',
  $enabled        = '',
  $banner         = '/etc/issue.net',
  $banner_success = '',
  $banner_fail    = '',
  $groups         = 'no',
  $cps            = '25 30',
  $max_load       = ''
  ) {
  include '::xinetd'

  validate_string($log_type)
  if !empty($x_bind) { validate_string($x_bind) }
  if !empty($per_source) { validate_re($per_source, '(^\d+$|UNLIMITED)') }
  if !empty($x_umask) { validate_umask($x_umask) }
  validate_string($log_on_success)
  validate_string($log_on_failure)
  if !empty($no_access) { validate_string($no_access) }
  if !empty($passenv) { validate_array($passenv) }
  validate_re($instances, '(^\d+$|UNLIMITED)')
  if !empty($disable) { validate_re('(yes|no)') }
  if !empty($disabled) { validate_string($disabled) }
  if !empty($enabled) { validate_string($enabled) }
  validate_string($banner)
  if !empty($banner_success) { validate_string($banner_success) }
  if !empty($banner_fail) { validate_string($banner_fail) }
  validate_re($groups, '(yes|no)')
  validate_re($cps, '^\d+\s\d+$')
  if !empty($max_load) { validate_re($max_load, '^(.?|\d+).?\d*$') }

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
}
