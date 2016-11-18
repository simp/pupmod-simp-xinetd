require 'spec_helper'

describe 'xinetd::service' do
  let :pre_condition do
    'include tcpwrappers'
  end

  let(:title) { 'tftp' }

  let(:params) { {:server => '/usr/sbin/in.tftpd', :port => '69', :protocol => 'udp', :x_wait => 'yes', :socket_type => 'dgram', :only_from => '127.0.0.1', :libwrap_name => 'in.tftpd'} }

  base_facts = {
    :interfaces => 'eth0'
  }
  let(:facts){base_facts}

  it do
    is_expected.to contain_file('/etc/xinetd.d/tftp').with({
      'owner' => 'root',
      'group' => 'root',
      'mode' => '0640'
    })
  end

  it do
    is_expected.to contain_iptables__add_udp_listen('allow_tftp').with({
      'order' => '11',
      'client_nets' => '127.0.0.1',
      'dports' => '69'
    })
  end

  it do
    is_expected.to contain_tcpwrappers__allow('in.tftpd').with({
      'pattern' => '127.0.0.1'
    })
  end

  context 'with protocol => tcp and libwrap_name => nil' do
    let(:params) { {:server => '/usr/sbin/in.tftpd', :x_wait => 'yes', :socket_type => 'dgram', :protocol => 'tcp', :only_from => '127.0.0.1', :port => '70'} }

    it do
      is_expected.to contain_iptables__add_tcp_stateful_listen('allow_tftp').with({
        'order' => '11',
        'client_nets' => '127.0.0.1',
        'dports' => '70'
      })
    end

    it do
      is_expected.to contain_tcpwrappers__allow('tftp').with({
        'pattern' => '127.0.0.1'
      })
    end
  end
end
