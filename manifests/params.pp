# == Class xinetd::params
#
# This class is meant to be called from xinetd.
# It sets variables according to platform.
#
class xinetd::params {
  case $::osfamily {
    'RedHat': {
      $package_name = 'xinetd'
      $service_name = 'xinetd'
    }
    'CentOS': {
      $package_name = 'xinetd'
      $service_name = 'xinetd'
    }default: {
      fail("${::operatingsystem} not supported")
    }
  }
}
