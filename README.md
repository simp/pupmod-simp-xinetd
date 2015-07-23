[![License](http://img.shields.io/:license-apache-blue.svg)](http://www.apache.org/licenses/LICENSE-2.0.html) [![Build Status](https://travis-ci.org/simp/pupmod-simp-xinetd.svg)](https://travis-ci.org/simp/pupmod-simp-xinetd) [![SIMP compatibility](https://img.shields.io/badge/SIMP%20compatibility-4.2.*%2F5.1.*-orange.svg)](https://img.shields.io/badge/SIMP%20compatibility-4.2.*%2F5.1.*-orange.svg)

#### Table of Contents

1. [Overview](#overview)
2. [This is a SIMP module](#this-is-a-simp-module)
3. [Module Description](#module-description)
  * [Dependencies](#dependencies)
4. [Setup](#setup)
  * [What xinetd affects](#what-xinetd-affects)
  * [Beginning with xinetd](#beginning-with-xinetd)
5. [Usage](#usage)
6. [Reference](#reference)
  * [Classes](#classes)
    * [xinetd ](#xinetd)
      * [Parameters](#parameters)
  * [Defines](#defines)
    * [xinetd::config::xinetd_service](#xinetdconfigxinetd_service)
      * [Common parameters](#common-parameters)
7. [Limitations](#limitations)
8. [Development](#development)

## Overview

This module provides tools for managing xinetd itself and individual xinetd services.

## This is a SIMP module

This module is a component of the [System Integrity Management Platform](https://github.com/NationalSecurityAgency/SIMP), a compliance-management framework built on Puppet.

This module is optimally designed for use within a larger SIMP ecosystem, but it can be used independently:
* When included within the SIMP ecosystem, security compliance settings will be managed from the Puppet server.
* If used independently, all SIMP-managed security subsystems are disabled by default, and must be explicitly opted into by administrators.  Please review the `$use_simp_firewall` and `$enable_*` parameters in `manifests/init.pp` for details.

## Module Description

**FIXME:** The text below is boilerplate copy.  Ensure that it is correct and remove this message!

If applicable, this section should have a brief description of the technology the module integrates with and what that integration enables. This section should answer the questions: "What does this module *do*?" and "Why would I use it?"

### Dependencies

This module depends on the following SIMP modules:
* [pupmod-simp-common](https://github.com/simp/pupmod-simp-common)
* [pupmod-simp-concat](https://github.com/simp/pupmod-simp-concat)
* [pupmod-simp-iptables](https://github.com/simp/pupmod-simp-iptables)
* [pupmod-simp-rsync](https://github.com/simp/pupmod-simp-rsync)
* [pupmod-simp-tcpwrappers](https://github.com/simp/pupmod-simp-tcpwrappers)
* [puppetlabs-stdlib](https://github.com/puppetlabs/puppetlabs-stdlib)

## Setup

### What xinetd affects

* The `xinetd` package
* The base xinetd configuration file, `/etc/xinetd.conf`
* The directory for configured services, `/etc/xinetd.d`
* If configured, iptables rules as prescribed by the xinetd services
* If configured, a tcpwrapper will be used

### Beginning with xinetd

For the most basic usage of this module, just include `xinetd` in your manifest.

To configure an xinetd service, `tftp` in this example, you must call `xinetd::config::xinetd_service`. A basic example:
```puppet
xinetd::config::xinetd_service { 'tftp':
  server   => '/usr/sbin/in.tftpd',
  protocol => '69',
  port     => 'udp',
}
```

## Usage

## Reference

### Classes

#### `xinetd`

##### Parameters

* **use_simp_firewall:** If `true`, the xinetd module will write firewall rules using the SIMP iptables module and iptables. If set to false, this module will not write any firewall rules. Default: false
* **enable_tcpwrappers:** If `true`, the module will configure tcpwrappers(tcpd) with xinetd services created by the module. Default: false

### Defines

#### `xinetd::config::xinetd_service`

##### Common parameters

* **server:** The executable for the service
* **port:** The port of the service to listen on
* **protocol:** The protocol that xinetd should be listening on. Accepts UDP and TCP.
* **log_type:** Determines where the service log output is sent
* **only_from:** a whitelist of hosts that are allowed to use the service

Please refer to the xinetd man page and `config/xinetd_service.pp` for more details on parameters available.

## Limitations

This module is only designed to work on Centos 6/7 and RHEL 6/7.

## Development

Please see the [SIMP Contribution Guidelines](https://simp-project.atlassian.net/wiki/display/SD/Contributing+to+SIMP).
