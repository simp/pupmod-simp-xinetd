require 'spec_helper'

describe 'xinetd::config::xinetd_service' do

  let(:title) { 'tftp' }

  let(:params) { {:server => '/usr/sbin/in.tftpd', :port => '69', :protocol => 'udp', :x_wait => 'yes', :socket_type => 'dgram', :only_from => '127.0.0.1', :libwrap_name => 'in.tftpd'} }

  base_facts = {
    :interfaces => 'eth0'
  }
  let(:facts){base_facts}

  it do
    should contain_file('/etc/xinetd.d/tftp').with({
      'owner' => 'root',
      'group' => 'root',
      'mode' => '0640'
    })
  end

end
