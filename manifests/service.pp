# == Class xinetd::service
#
# This class is meant to be called from xinetd.
# It ensure the service is running.
#
# == Authors
#
# * Trevor Vaughan <mailto:tvaughan@onyxpoint.com>
# * Nick Miller <mailto:nick.miller@onyxpoint.com>
#
class xinetd::service inherits xinetd {
  include '::xinetd'

  service { 'xinetd':
    ensure    => 'running',
    enable    => true,
    hasstatus => true,
    restart   => '( /bin/ps -C xinetd && /sbin/service xinetd reload ) || /sbin/service xinetd start',
    require   => Package['xinetd']
  }
}
