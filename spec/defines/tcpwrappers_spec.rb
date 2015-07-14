require 'spec_helper'

describe 'xinetd::tcpwrappers::xinetd_service' do

  let(:title) { 'tftp' }

  let(:params) { {
    :only_from    => '127.0.0.1',
    :libwrap_name => 'in.tftpd'
  } }

  shared_examples_for "xinetd::tcpwrappers::xinetd_service" do
    it do
      is_expected.to contain_tcpwrappers__allow('in.tftpd').with({ 'pattern' => '127.0.0.1' })
    end
  end

  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:facts) do
          facts[:lsbmajdistrelease] = facts[:operatingsystemmajrelease]
          facts
        end

        context "create firewall rules for a tftp service" do
          it_behaves_like "xinetd::tcpwrappers::xinetd_service"
        end

      end
    end
  end

end
