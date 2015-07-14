# == Define xinetd::tcpwrappers::xinetd_service
#
# xinetd::tcpwrappers::xinetd_service service refers to an xinetd-managed service,
# not the xinetd ::service itself.
#
# == Parameters
#
# For the identification of what these options should be, consult the
# xinetd.conf(5) man page.
#
# == Authors
#
# Trevor Vaughan <mailto:tvaughan@onyxpoint.com>
# Nick Miller <mailto:nick.miller@onyxpoint.com>
#
define xinetd::tcpwrappers::xinetd_service (
  $only_from = 'nil',
  $libwrap_name = 'nil'
) {

  case $libwrap_name {
    'nil':  {
      tcpwrappers::allow { $name:
        pattern => $only_from
      }
    }
    default:  {
      tcpwrappers::allow { $libwrap_name:
        pattern => $only_from
      }
    }
  }

}
