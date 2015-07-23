require 'spec_helper'

describe 'xinetd::config::xinetd_service' do

  let(:title) { 'tftp' }

  let(:params) { {
    :server => '/usr/sbin/in.tftpd',
    :port => '69',
    :protocol => 'udp',
    :x_wait => 'yes',
    :socket_type => 'dgram',
    :only_from => '127.0.0.1',
    :libwrap_name => 'in.tftpd'
  } }

  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:facts) do
          facts[:lsbmajdistrelease] = facts[:operatingsystemmajrelease]
          facts
        end

        context "create service file for tftp" do
          it do
            is_expected.to contain_service('xinetd').with({
              'ensure'    => 'running',
              'enable'    => true,
            })
            is_expected.to contain_file('/etc/xinetd.d/tftp').with({
              'owner' => 'root',
              'group' => 'root',
              'mode' => '0640'
            })
          end
        end

      end
    end
  end

end
