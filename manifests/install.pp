# == Class xinetd::install
#
# This class is called from xinetd for install.
#
# == Authors
#
# * Trevor Vaughan <mailto:tvaughan@onyxpoint.com>
# * Nick Miller <mailto:nick.miller@onyxpoint.com>
#
class xinetd::install inherits ::xinetd {

  package { 'xinetd': ensure => 'latest' }
}
