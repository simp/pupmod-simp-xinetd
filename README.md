[![License](https://img.shields.io/:license-apache-blue.svg)](http://www.apache.org/licenses/LICENSE-2.0.html)
[![CII Best Practices](https://bestpractices.coreinfrastructure.org/projects/73/badge)](https://bestpractices.coreinfrastructure.org/projects/73)
[![Puppet Forge](https://img.shields.io/puppetforge/v/simp/xinetd.svg)](https://forge.puppetlabs.com/simp/xinetd)
[![Puppet Forge Downloads](https://img.shields.io/puppetforge/dt/simp/xinetd.svg)](https://forge.puppetlabs.com/simp/xinetd)
[![Build Status](https://travis-ci.org/simp/pupmod-simp-xinetd.svg)](https://travis-ci.org/simp/pupmod-simp-xinetd)

<!-- vim-markdown-toc GFM -->

  * [This is a SIMP module](#this-is-a-simp-module)
  * [Module Description](#module-description)
  * [Examples](#examples)
    * [Set up an 'uptime' service](#set-up-an-uptime-service)
    * [Set up VNC forwarding](#set-up-vnc-forwarding)
  * [Reference](#reference)
* [Development](#development)

<!-- vim-markdown-toc -->

## This is a SIMP module

This module is a component of the [System Integrity Management Platform](https://simp-project.com),
a compliance-management framework built on Puppet.

If you find any issues, they can be submitted to our [JIRA](https://simp-project.atlassian.net/).

Please read our [Contribution Guide](https://simp.readthedocs.io/en/stable/contributors_guide/index.html).

## Module Description

This module provides for configuration of the `xinetd` daemon and allows users
manage services to run under `xinetd`.

## Examples

### Set up an 'uptime' service

```puppet
xinetd::service { 'uptime':
  server       => '/usr/bin/uptime',
  port         => 12345,
  protocol     => 'tcp',
  user         => 'nobody',
  x_type       => 'UNLISTED',
  x_wait       => 'no',
  socket_type  => 'stream',
  trusted_nets => ['ALL']
```

### Set up VNC forwarding

For this example, an SSH tunnel is expected to be used.

```puppet
xinetd::service { 'my_vnc':
  banner       => '/dev/null',
  flags        => ['REUSE','IPv4'],
  protocol     => 'tcp',
  socket_type  => 'stream',
  x_wait       => 'no',
  x_type       => 'UNLISTED',
  user         => 'nobody',
  server       => '/usr/bin/Xvnc',
  server_args  => "-inetd -localhost -audit 4 -s 15 -query localhost -NeverShared -once -SecurityTypes None -desktop my_vnc -geometry 800x600 -depth 16"
  disable      => 'no',
  trusted_nets => ['127.0.0.1'],
  port         => 23456
}
```

## Reference

Plesae see [REFERENCE.md](./REFERENCE.md) for a full details.

# Development

Please read our [Contribution Guide](https://simp.readthedocs.io/en/stable/contributors_guide/index.html).

Visit the [project homepage](https://simp-project.com) and look at our issues on
[JIRA](https://simp-project.atlassian.net).
