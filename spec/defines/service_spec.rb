require 'spec_helper'

shared_examples_for 'a xinetd::service' do
  it { is_expected.to compile.with_all_deps }
  it { is_expected.to contain_class('xinetd') }
end

describe 'xinetd::service' do
  context 'supported operating systems' do
    on_supported_os.each do |os, os_facts|
      context "on #{os}" do

        let(:facts) {os_facts}
        let(:title) { 'tftp' }
        let(:required_params) {{
          :server      => '/usr/sbin/in.tftpd',
          :port        => 69,
          :protocol    => 'udp',
          :x_wait      => 'yes',
          :socket_type => 'dgram',
        }}

        context 'default parameters' do
          let(:params) { required_params }

  it { is_expected.to compile.with_all_deps }
  #        it_should_behave_like 'a xinetd::service'
          it do
            is_expected.to contain_file('/etc/xinetd.d/tftp').with({
              'owner'   => 'root',
              'group'   => 'root',
              'mode'    => '0640',
              'content' => <<EOM
service tftp
{
    socket_type = dgram
    user = root
    server = /usr/sbin/in.tftpd
    wait = yes
    disable = no
    log_type = SYSLOG authpriv
    log_on_success = HOST PID DURATION TRAFFIC
    log_on_failure = HOST
    port = 69
    umask = 027
    protocol = udp
    only_from = 127.0.0.1 ::1

}

EOM
            })
          end
          it { is_expected.to_not contain_class('iptables') }
          it { is_expected.to_not contain_class('tcpwrappers') }
        end

        context 'optional parameters set' do
          let(:params) { required_params.merge({
            :libwrap        => 'mylibwrap',
            :x_id           => 'serviceid',
            :x_type         => 'RPC',
            :flags          => ['NODELAY'],
            :group          => 'groupx',
            :instances      => 10,
            :nice           => 6,
            :server_args    => '-i 3',
            :access_times   => '00:00-23:59',
            :rpc_version    => '2',
            :rpc_number     => 4,
            :env            => 'SOMEENV1=value1 SOMENV2=value2',
            :passenv        => 'SOMENV3',
            :redirect_ip    => '1.2.3.4',
            :redirect_port  => 8080,
            :x_bind         => '1.2.3.7',
            :banner         => '/some/banner.txt',
            :banner_success => '/some/banner_success.txt',
            :banner_fail    => '/some/banner_fail.txt',
            :per_source     => 3,
            :cps            => [60,6],
            :max_load       => 2.6,
            :groups         => 'yes',
            :mdns           => 'no',
            :enabled        => ['service_id1', 'service_id2'],
            :include        => '/etc/xinetd/servicex',
            :includedir     => '/etc/xinetd.d/some/sub/dir',
            :rlimit_as      => 'UNLIMITED',
            :rlimit_cpu     => '3',
            :rlimit_data    => '4',
            :rlimit_rss     => '5',
            :rlimit_stack   => '6',
            :deny_time      => 'FOREVER'
          }) }
          it_should_behave_like 'a xinetd::service'
          it do
            is_expected.to contain_file('/etc/xinetd.d/tftp').with({
              'owner' => 'root',
              'group' => 'root',
              'mode'  => '0640',
              'content' => <<EOM
service tftp
{
    socket_type = dgram
    user = root
    server = /usr/sbin/in.tftpd
    wait = yes
    disable = no
    log_type = SYSLOG authpriv
    log_on_success = HOST PID DURATION TRAFFIC
    log_on_failure = HOST
    port = 69
    umask = 027
    id = serviceid
    type = RPC
    flags = NODELAY
    protocol = udp
    group = groupx
    nice = 6
    server_args = -i 3
    libwrap = mylibwrap
    only_from = 127.0.0.1 ::1
    instances = 10
    access_times = 00:00-23:59
    rpc_version = 2
    rpc_number = 4
    env = SOMEENV1=value1 SOMENV2=value2
    passenv = SOMENV3
    redirect = 1.2.3.4 8080
    bind = 1.2.3.7
    banner = /some/banner.txt
    banner_success = /some/banner_success.txt
    banner_fail = /some/banner_fail.txt
    per_source = 3
    cps = 60 6
    max_load = 2.6
    groups = yes
    mdns = no
    enabled = service_id1 service_id2
    rlimit_as = UNLIMITED
    rlimit_cpu = 3
    rlimit_data = 4
    rlimit_rss = 5
    rlimit_stack = 6
    deny_time = FOREVER
}

include /etc/xinetd/servicex
includedir /etc/xinetd.d/some/sub/dir
EOM
            })
          end
        end

        context 'with firewall enabled' do
          context 'with tcp proto' do
            let(:params) { required_params.merge({
              :firewall => true,
              :protocol => 'tcp'
            }) }

            it_should_behave_like 'a xinetd::service'
            it { is_expected.to contain_class('iptables') }
            it do
             is_expected.to contain_iptables__listen__tcp_stateful('allow_tftp').with({
                'order' => 11,
                'trusted_nets' => ['127.0.0.1', '::1'],
                'dports' => 69
              })
            end
          end

          context 'with udp proto' do
            let(:params) { required_params.merge({
              :firewall => true,
              :protocol => 'udp'
            }) }

            it_should_behave_like 'a xinetd::service'
            it { is_expected.to contain_class('iptables') }
            it do
              is_expected.to contain_iptables__listen__udp('allow_tftp').with({
                'order' => 11,
                'trusted_nets' => ['127.0.0.1', '::1'],
                'dports' => 69
              })
            end
          end
        end

        context 'with tcpwrappers enabled' do
          context 'without libwrap_name' do
            let(:params) { required_params.merge({
              :tcpwrappers => true
            }) }

            it_should_behave_like 'a xinetd::service'
            it { is_expected.to contain_class('tcpwrappers') }
            it do
              is_expected.to contain_tcpwrappers__allow('tftp').with({
                'pattern' => ['127.0.0.1', '::1']
              })
            end
          end

          context 'with libwrap_name' do
            let(:params) { required_params.merge({
              :tcpwrappers => true,
              :libwrap_name => 'in.tftpd'
            }) }

            it_should_behave_like 'a xinetd::service'
            it { is_expected.to contain_class('tcpwrappers') }
            it do
              is_expected.to contain_tcpwrappers__allow('in.tftpd').with({
                'pattern' => ['127.0.0.1', '::1']
              })
            end
          end
        end
      end
    end
  end
end
