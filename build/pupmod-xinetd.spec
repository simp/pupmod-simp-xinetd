Summary: Xinetd Puppet Module
Name: pupmod-xinetd
Version: 2.1.0
Release: 4
License: Apache License, Version 2.0
Group: Applications/System
Source: %{name}-%{version}-%{release}.tar.gz
Buildroot: %{_tmppath}/%{name}-%{version}-%{release}-buildroot
Requires: pupmod-rsync
Requires: pupmod-iptables >= 2.0.0-0
Requires: pupmod-tcpwrappers
Requires: puppet >= 3.3.0
Buildarch: noarch
Requires: simp-bootstrap >= 4.2.0
Obsoletes: pupmod-xinetd-test

Prefix: /etc/puppet/environments/simp/modules

%description
This Puppet module provides the capability to configure various aspects of the
xinetd service.  /etc/xinetd.conf is pulled from the central server using rsync.

%prep
%setup -q

%build

%install
[ "%{buildroot}" != "/" ] && rm -rf %{buildroot}

mkdir -p %{buildroot}/%{prefix}/xinetd

dirs='files lib manifests templates'
for dir in $dirs; do
  test -d $dir && cp -r $dir %{buildroot}/%{prefix}/xinetd
done

%clean
[ "%{buildroot}" != "/" ] && rm -rf %{buildroot}

mkdir -p %{buildroot}/%{prefix}/xinetd

%files
%defattr(0640,root,puppet,0750)
%{prefix}/xinetd

%post
#!/bin/sh

%postun
# Post uninstall stuff

%changelog
* Tue Nov 10 2015 Chris Tessmer <chris.tessmer@onypoint.com> - 2.1.0-4
- migration to simplib and simpcat (lib/ only)

* Mon Apr 06 2015 Trevor Vaughan <tvaughan@onyxpoint.com> - 2.1.0-3
- Updated the default log_type to 'SYSLOG authpriv'

* Fri Jan 16 2015 Trevor Vaughan <tvaughan@onyxpoint.com> - 2.1.0-2
- Changed puppet-server requirement to puppet

* Sun Jun 22 2014 Kendall Moore <kmoore@keywcorp.com> - 2.1.0-1
- Removed MD5 file checksums for FIPS compliance.

* Thu Jun 19 2014 Trevor Vaughan <tvaughan@onyxpoint.com> - 2.1.0-1
- Ensure that 'lfrom' in xinetd.conf.erb is not converted to an Array
  explicitly.

* Fri Jan 3 2014 Nick Markowski <nmarkowski@keywcorp.com> - 2.1.0-0
- Updated module for puppet3/hiera compatibility, and optimized code for lint tests,
  and puppet-rspec.

* Tue Oct 08 2013 Nick Markowski <nmarkowski@keywcorp.com> - 2.0.0-7
- Updated template to reference instance variables with @

* Fri Nov 30 2012 Maintenance
2.0.0-6
- Created a Cucumber test to ensure that xinetd installs correctly when adding
  include xinetd in the puppet server manifest.

* Thu Jun 07 2012 Maintenance
2.0.0-5
- Ensure that Arrays in templates are flattened.
- Call facts as instance variables.
- Moved mit-tests to /usr/share/simp...
- Converted internal nets2cidr code to use the 'common' function.
- Updated pp files to better meet Puppet's recommended style guide.

* Fri Apr 06 2012 Maintenance
2.0.0-4
- Templated xinetd.conf.

* Fri Mar 02 2012 Maintenance
2.0.0-3
- Improved test stubs.

* Mon Dec 26 2011 Maintenance
2.0.0-2
- Updated the spec file to not require a separate file list.

* Fri Feb 04 2011 Maintenance - 2.0.0-1
- Changed all instances of defined(Class['foo']) to defined('foo') per the
  directions from the Puppet mailing list.
- Updated to use rsync native type

* Tue Jan 11 2011 Maintenance
2.0.0-0
- Refactored for SIMP-2.0.0-alpha release

* Tue Oct 26 2010 Maintenance - 1-2
- Converting all spec files to check for directories prior to copy.

* Thu Sep 09 2010 Maintenance
1.0-1
- Replaced tcpwrappers::tcpwrappers_allow with tcpwrappers::allow.

* Mon May 24 2010 Maintenance
1.0-0
- Code refactoring.

* Thu Oct 1 2009 Maintenance
0.1-11
- Removed much of the unnecessary whitespace from the template file results.
