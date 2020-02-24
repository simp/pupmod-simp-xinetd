# Valid flags values from xinetd.conf(5)
type Xinetd::Flags = Enum[
  'INTERCEPT',
  'NORETRY',
  'IDONLY',
  'NAMEINARGS',
  'NODELAY',
  'KEEPALIVE',
  'NOLIBWRAP',
  'SENSOR',
  'IPv4',
  'IPv6',
  'LABELED',
  'REUSE'
]
