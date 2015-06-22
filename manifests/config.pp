# == Class xinetd::config
#
# This class is called from xinetd for service config.
#
# == Authors
#
# * Trevor Vaughan <mailto:tvaughan@onyxpoint.com>
# * Nick Miller <mailto:nick.miller@onyxpoint.com>
#
class xinetd::config {
  include '::xinetd'

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
