require 'spec_helper'

describe 'xinetd::firewall::xinetd_service' do

  let(:title) { 'tftp' }

  let(:params) { {
  # :server       => '/usr/sbin/in.tftpd',
    :port         => '69',
    :protocol     => 'udp',
  # :x_wait       => 'yes',
  # :socket_type  => 'dgram',
    :only_from    => '127.0.0.1',
    :libwrap_name => 'in.tftpd'
  } }

  simp_os_facts = {
    'CentOS' => {
      '6' => {
      'x86_64' => {
          :grub_version => '0.97',
          :uid_min      => '500',
        },
      },
      '7' => {
      'x86_64' => {
          :grub_version => '2.02~beta2',
          :uid_min      => '500',
        },
      },
    },
    'RedHat' => {
      '6' => {
      'x86_64' => {
          :grub_version => '0.97',
          :uid_min      => '500',
        },
      },
      '7' => {
      'x86_64' => {
          :grub_version => '2.02~beta2',
          :uid_min      => '500',
        },
      },
    },
    :interfaces => 'eth0'
  }
  # base_facts = {
  #   :interfaces => 'eth0'
  # }
  let(:facts){simp_os_facts}


  shared_examples_for "xinetd::firewall::xinetd_service" do
    it do
      is_expected.to contain_iptables__add_udp_listen('allow_tftp').with({
        'order'       => '11',
        'client_nets' => '127.0.0.1',
        'dports'      => '69'
      })
    end

    # it do
    #   is_expected.to contain_tcpwrappers__allow('in.tftpd').with({ 'pattern' => '127.0.0.1' })
    # end

    context 'with protocol => tcp and libwrap_name => nil' do
      let(:params) { {
      # :server      => '/usr/sbin/in.tftpd',
      # :x_wait      => 'yes',
      # :socket_type => 'dgram',
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
      # it do
      #   is_expected.to contain_tcpwrappers__allow('tftp').with({ 'pattern' => '127.0.0.1' })
      # end
    end
  end

  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      context "on #{os}" do
        let(:facts) do
          # FIXME: create simp-rspec-puppet-facts (SIMP-207)
          facts[:lsbmajdistrelease] = facts[:operatingsystemmajrelease]
          # FIXME: one
          simp_facts = simp_os_facts.fetch( facts.fetch(:operatingsystem) ).fetch( facts.fetch(:operatingsystemmajrelease) ).fetch( facts.fetch(:architecture) )

             # require 'pp'
             # puts "------------- FACTS"
             # pp simp_facts
          facts
        end

        context "create firewall rules for tftp xinetd" do
          it_behaves_like "xinetd::firewall::xinetd_service"
        end

      end
    end
  end

end
