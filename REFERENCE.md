# Reference
<!-- DO NOT EDIT: This document was generated by Puppet Strings -->

## Table of Contents

**Classes**

* [`xinetd`](#xinetd): Set up xinetd

**Defined types**

* [`xinetd::service`](#xinetdservice): Configure the xinetd service

**Functions**

* [`xinetd::validate_log_type`](#xinetdvalidate_log_type): Perform validation on the log_type variable, as described in the man page of xinetd.conf(5)

**Data types**

* [`Xinetd::AccessTimes`](#xinetdaccesstimes): Valid access_times from xinetd.conf(5)
* [`Xinetd::DenyTime`](#xinetddenytime): Valid deny_time values from xinetd.conf(5)
* [`Xinetd::FailureLogOption`](#xinetdfailurelogoption): Valid failure_log_option values from xinetd.conf(5)
* [`Xinetd::Flags`](#xinetdflags): Valid flags values from xinetd.conf(5)
* [`Xinetd::RpcVersion`](#xinetdrpcversion): Valid rpc_version values from xinetd.conf(5)
* [`Xinetd::SocketType`](#xinetdsockettype): Valid socket_type values from xinetd.conf(5)
* [`Xinetd::SuccessLogOption`](#xinetdsuccesslogoption): Valid success_log_option values from xinetd.conf(5)
* [`Xinetd::Type`](#xinetdtype): Valid type values from xinetd.conf(5)
* [`Xinetd::UnlimitedInt`](#xinetdunlimitedint): Entries that may be either 'UNLIMITED' or an Integer  TODO rlimit_as regex should accept K or M qualifiers

## Classes

### xinetd

This is incomplete but should suffice for most purposes.

NOTE: Items prefixed with 'x_' were reserved words in ERB.
* xinetd/xinetd.conf.erb

Explanations of the options can be found in the xinetd.conf(5) man page.

#### Parameters

The following parameters are available in the `xinetd` class.

##### `log_type`

Data type: `String[1]`



Default value: 'SYSLOG authpriv'

##### `x_bind`

Data type: `Optional[String[1]]`



Default value: `undef`

##### `per_source`

Data type: `Optional[Xinetd::UnlimitedInt]`



Default value: `undef`

##### `x_umask`

Data type: `Optional[Simplib::Umask]`



Default value: `undef`

##### `log_on_success`

Data type: `Array[Xinetd::SuccessLogOption]`



Default value: ['HOST','PID','DURATION']

##### `log_on_failure`

Data type: `Array[Xinetd::FailureLogOption]`



Default value: ['HOST']

##### `trusted_nets`

Data type: `Simplib::Netlist`



Default value: lookup('simp_options::trusted_nets', { 'default_value' => ['127.0.0.1', '::1'] })

##### `no_access`

Data type: `Optional[Array[String[1]]]`



Default value: `undef`

##### `passenv`

Data type: `Optional[String[1]]`



Default value: `undef`

##### `instances`

Data type: `Xinetd::UnlimitedInt`



Default value: '60'

##### `disabled`

Data type: `Optional[Array[String[1]]]`



Default value: `undef`

##### `disable`

Data type: `Optional[Enum['yes','no']]`



Default value: `undef`

##### `enabled`

Data type: `Optional[Array[String[1]]]`



Default value: `undef`

##### `banner`

Data type: `Stdlib::Absolutepath`



Default value: '/etc/issue.net'

##### `banner_success`

Data type: `Optional[Stdlib::Absolutepath]`



Default value: `undef`

##### `banner_fail`

Data type: `Optional[Stdlib::Absolutepath]`



Default value: `undef`

##### `groups`

Data type: `Enum['yes','no']`



Default value: 'no'

##### `cps`

Data type: `Tuple[Integer[1],Integer[1]]`



Default value: [25,30]

##### `max_load`

Data type: `Optional[Float[0]]`



Default value: `undef`

##### `purge`

Data type: `Boolean`

Purge all unmanaged services

Default value: `false`

##### `package_ensure`

Data type: `String[1]`

The ``package`` resource ensure to apply to all included package resources

Default value: simplib::lookup('simp_options::package_ensure', { 'default_value' => 'installed' })

## Defined types

### xinetd::service

For the identification of what these options should be, consult the
xinetd.conf(5) man page.

Items prefixed with 'x_' were reserved words in ERB.
* xinetd/xinetd.service.erb

#### Parameters

The following parameters are available in the `xinetd::service` defined type.

##### `server`

Data type: `String`



##### `port`

Data type: `Simplib::Port`



##### `protocol`

Data type: `String`



##### `x_wait`

Data type: `Enum['yes','no']`



##### `socket_type`

Data type: `Xinetd::SocketType`



##### `disable`

Data type: `Enum['yes','no']`



Default value: 'no'

##### `libwrap_name`

Data type: `Optional[String]`



Default value: `undef`

##### `libwrap`

Data type: `Optional[String]`



Default value: `undef`

##### `user`

Data type: `String`



Default value: 'root'

##### `x_umask`

Data type: `Simplib::Umask`



Default value: '027'

##### `log_type`

Data type: `String`



Default value: 'SYSLOG authpriv'

##### `log_on_success`

Data type: `Array[Xinetd::SuccessLogOption]`



Default value: ['HOST','PID','DURATION']

##### `log_on_failure`

Data type: `Array[Xinetd::FailureLogOption]`



Default value: ['HOST']

##### `x_id`

Data type: `Optional[String]`



Default value: `undef`

##### `x_type`

Data type: `Optional[Xinetd::Type]`



Default value: `undef`

##### `flags`

Data type: `Optional[Array[Xinetd::Flags]]`



Default value: `undef`

##### `group`

Data type: `Optional[String]`



Default value: `undef`

##### `instances`

Data type: `Optional[Xinetd::UnlimitedInt]`



Default value: `undef`

##### `nice`

Data type: `Optional[Integer]`



Default value: `undef`

##### `server_args`

Data type: `Optional[String]`



Default value: `undef`

##### `trusted_nets`

Data type: `Simplib::Netlist`



Default value: simplib::lookup('simp_options::trusted_nets', { 'default_value' => ['127.0.0.1', '::1'] })

##### `access_times`

Data type: `Optional[Xinetd::AccessTimes]`



Default value: `undef`

##### `rpc_version`

Data type: `Optional[Xinetd::RpcVersion]`



Default value: `undef`

##### `rpc_number`

Data type: `Optional[Integer]`



Default value: `undef`

##### `env`

Data type: `Optional[String]`



Default value: `undef`

##### `passenv`

Data type: `Optional[String]`



Default value: `undef`

##### `redirect_ip`

Data type: `Optional[Simplib::IP]`



Default value: `undef`

##### `redirect_port`

Data type: `Optional[Simplib::Port]`



Default value: `undef`

##### `x_bind`

Data type: `Optional[String]`



Default value: `undef`

##### `banner`

Data type: `Optional[Stdlib::Absolutepath]`



Default value: `undef`

##### `banner_success`

Data type: `Optional[Stdlib::Absolutepath]`



Default value: `undef`

##### `banner_fail`

Data type: `Optional[Stdlib::Absolutepath]`



Default value: `undef`

##### `per_source`

Data type: `Optional[Xinetd::UnlimitedInt]`



Default value: `undef`

##### `cps`

Data type: `Optional[Tuple[Integer,Integer]]`



Default value: `undef`

##### `max_load`

Data type: `Optional[Float]`



Default value: `undef`

##### `groups`

Data type: `Optional[Enum['yes','no']]`



Default value: `undef`

##### `mdns`

Data type: `Optional[Enum['yes','no']]`



Default value: `undef`

##### `enabled`

Data type: `Optional[Array[String]]`



Default value: `undef`

##### `include`

Data type: `Optional[Stdlib::Absolutepath]`



Default value: `undef`

##### `includedir`

Data type: `Optional[Stdlib::Absolutepath]`



Default value: `undef`

##### `rlimit_as`

Data type: `Optional[Xinetd::UnlimitedInt]`



Default value: `undef`

##### `rlimit_cpu`

Data type: `Optional[Xinetd::UnlimitedInt]`



Default value: `undef`

##### `rlimit_data`

Data type: `Optional[Xinetd::UnlimitedInt]`



Default value: `undef`

##### `rlimit_rss`

Data type: `Optional[Xinetd::UnlimitedInt]`



Default value: `undef`

##### `rlimit_stack`

Data type: `Optional[Xinetd::UnlimitedInt]`



Default value: `undef`

##### `deny_time`

Data type: `Optional[Xinetd::DenyTime]`



Default value: `undef`

##### `firewall`

Data type: `Boolean`

Enable the SIMP firewall module functionality

Default value: simplib::lookup('simp_options::firewall', { 'default_value' => false })

##### `tcpwrappers`

Data type: `Boolean`

Enable the SIMP tcpwrappers module functionality

Default value: simplib::lookup('simp_options::tcpwrappers', { 'default_value' => false })

## Functions

### xinetd::validate_log_type

Type: Ruby 4.x API

Perform validation on the log_type variable, as described in
the man page of xinetd.conf(5)

#### `xinetd::validate_log_type(String $log_type)`

Perform validation on the log_type variable, as described in
the man page of xinetd.conf(5)

Returns: `Any` true upon validation success

Raises:
* `upon` validation failure

##### `log_type`

Data type: `String`

Log specification for xinetd.conf log_type variable

## Data types

### Xinetd::AccessTimes

Valid access_times from xinetd.conf(5)

Alias of `Pattern[/^([01]?[0-9]|2[0-3]):[0-5][0-9]-([01]?[0-9]|2[0-3]):[0-5][0-9]$/]`

### Xinetd::DenyTime

Valid deny_time values from xinetd.conf(5)

Alias of `Pattern[/^((\d+)|(FOREVER|NEVER))$/]`

### Xinetd::FailureLogOption

Valid failure_log_option values from xinetd.conf(5)

Alias of `Enum['HOST', 'USERID', 'ATTEMPT']`

### Xinetd::Flags

Valid flags values from xinetd.conf(5)

Alias of `Enum['INTERCEPT', 'NORETRY', 'IDONLY', 'NAMEINARGS', 'NODELAY', 'KEEPALIVE', 'NOLIBWRAP', 'SENSOR', 'IPv4', 'IPv6', 'LABELED', 'REUSE']`

### Xinetd::RpcVersion

Valid rpc_version values from xinetd.conf(5)

Alias of `Pattern[/^\d+(-\d)*$/]`

### Xinetd::SocketType

Valid socket_type values from xinetd.conf(5)

Alias of `Enum['stream', 'dgram', 'raw', 'seqpacket']`

### Xinetd::SuccessLogOption

Valid success_log_option values from xinetd.conf(5)

Alias of `Enum['PID', 'HOST', 'USERID', 'EXIT', 'DURATION', 'TRAFFIC']`

### Xinetd::Type

Valid type values from xinetd.conf(5)

Alias of `Enum['RPC', 'INTERNAL', 'TCPMUX', 'TCPMUXPLUS', 'UNLISTED']`

### Xinetd::UnlimitedInt

Entries that may be either 'UNLIMITED' or an Integer

TODO rlimit_as regex should accept K or M qualifiers

Alias of `Variant[Integer, Pattern[/(^\d+$|UNLIMITED)/]]`

