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
# * Trevor Vaughan <mailto:tvaughan@onyxpoint.com>
# * Nick Miller <mailto:nick.miller@onyxpoint.com>
#
class xinetd {

  include '::xinetd::install'
  include '::xinetd::config'
  include '::xinetd::service'

  Class['::xinetd::install'] ~>
  Class['::xinetd::config'] ~>
  Class['::xinetd::service']

}
