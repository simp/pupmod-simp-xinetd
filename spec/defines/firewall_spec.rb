require 'spec_helper'

describe 'xinetd::firewall::xinetd_service' do

  let(:title) { 'tftp' }

  let(:params) { {
    :port         => '69',
    :protocol     => 'udp',
    :only_from    => '127.0.0.1',
    :libwrap_name => 'in.tftpd'
  } }

  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:facts) do
          facts[:lsbmajdistrelease] = facts[:operatingsystemmajrelease]
          facts
        end

        context "create firewall rules for tftp xinetd" do
          it do
            is_expected.to contain_iptables__add_udp_listen('allow_tftp').with({
              'order'       => '11',
              'client_nets' => '127.0.0.1',
              'dports'      => '69'
            })
          end

          context 'with protocol => tcp and libwrap_name => nil' do
            let(:params) { {
              :protocol    => 'tcp',
              :only_from   => '127.0.0.1',
              :port        => '70'
            } }
            it do
              is_expected.to contain_iptables__add_tcp_stateful_listen('allow_tftp').with({
                'order'       => '11',
                'client_nets' => '127.0.0.1',
                'dports'      => '70'
              })
            end
          end
        end

      end
    end
  end

end
