require 'spec_helper'
shared_examples_for 'a xinetd class' do
  it { is_expected.to compile.with_all_deps }
  it { is_expected.to create_class('xinetd') }
  it do
    is_expected.to contain_file('/etc/xinetd.d').with({
      'ensure'  => 'directory',
      'owner'   => 'root',
      'group'   => 'root',
      'mode'    => '0640',
      'recurse' => 'true'
    })
  end
  it { is_expected.to contain_service('xinetd') }
  it { is_expected.to contain_package('xinetd').with({:ensure => 'latest'}) }
  it { is_expected.to contain_package('xinetd').that_comes_before('Service[xinetd]') }
  it { is_expected.to contain_package('xinetd').that_comes_before('File[/etc/xinetd.conf]') }
  it { is_expected.to contain_package('xinetd').that_comes_before('File[/etc/xinetd.d]') }
end

describe 'xinetd' do
 context 'supported operating systems' do
    on_supported_os.each do |os, os_facts|
      context "on #{os}" do
        let(:facts){os_facts}

        context 'default parameters' do
          it_should_behave_like 'a xinetd class'

          it do
            is_expected.to contain_file('/etc/xinetd.conf').with({
              'owner'   => 'root',
              'group'   => 'root',
              'mode'    => '0600',
              'content' => <<EOM
defaults
{
  log_type       = SYSLOG authpriv
  log_on_success = HOST PID DURATION TRAFFIC
  log_on_failure = HOST
  only_from      = 127.0.0.1 ::1
  instances      = 60
  banner         = /etc/issue.net
  groups         = no
  cps            = 25 30
}

includedir /etc/xinetd.d
EOM
            })
          end
        end

        context 'optional parameters set' do
          let(:params) {{
            :x_bind         => '1.2.3.6',
            :per_source     => 'UNLIMITED',
            :x_umask        => '0700',
            :trusted_nets   => ['1.2.3.0/24', '10.0.2.5', '2001:db8:a::/64'],
            :no_access      => '1.2.3.4',
            :passenv        => 'SOMEENVVAR1 SOMENVVAR2',
            :disabled       => 'some_disabled_id1 some_disabled_id2',
            :disable        => 'yes',
            :enabled        => 'some_enabled_d1 some_enabled_id2',
            :banner_success => '/some/banner_success.txt',
            :banner_fail    => '/some/banner_fail.txt',
            :max_load       => '2.5',
          }}
          it_should_behave_like 'a xinetd class'
          it do
            is_expected.to contain_file('/etc/xinetd.conf').with({
              'owner'   => 'root',
              'group'   => 'root',
              'mode'    => '0600',
              'content' => <<EOM
defaults
{
  log_type       = SYSLOG authpriv
  bind           = 1.2.3.6
  per_source     = UNLIMITED
  umask          = 0700
  log_on_success = HOST PID DURATION TRAFFIC
  log_on_failure = HOST
  only_from      = 1.2.3.0/24 10.0.2.5 2001:db8:a::/64
  no_access      = 1.2.3.4
  passenv        = SOMEENVVAR1 SOMENVVAR2
  instances      = 60
  disabled       = some_disabled_id1 some_disabled_id2
  disable        = yes
  enabled        = some_enabled_d1 some_enabled_id2
  banner         = /etc/issue.net
  banner_success = /some/banner_success.txt
  banner_fail    = /some/banner_fail.txt
  groups         = no
  cps            = 25 30
  max_load       = 2.5
}

includedir /etc/xinetd.d
EOM
            })
          end
        end
      end
    end
  end
end
