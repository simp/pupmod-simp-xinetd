require 'spec_helper'

describe 'xinetd' do

  simp_os_facts = {
    'CentOS' => {
      '6' => {
      'x86_64' => {
          :grub_version              => '0.97',
          :uid_min                   => '500',
        },
      },
      '7' => {
      'x86_64' => {
          :grub_version              => '2.02~beta2',
          :uid_min                   => '500',
        },
      },
    },
    'RedHat' => {
      '6' => {
      'x86_64' => {
          :grub_version              => '0.97',
          :uid_min                   => '500',
        },
      },
      '7' => {
      'x86_64' => {
          :grub_version              => '2.02~beta2',
          :uid_min                   => '500',
        },
      },
    },
    :interfaces => 'eth0'
  }
  # base_facts = {
  #   :interfaces => 'eth0'
  # }
  let(:facts){simp_os_facts}

  shared_examples_for "xinetd" do
    it { is_expected.to compile.with_all_deps }
    it { is_expected.to create_class('xinetd') }
    it { is_expected.to create_class('xinetd::install').that_comes_before('xinetd::config') }
    it { is_expected.to create_class('xinetd::config') }
    it { is_expected.to create_class('xinetd::service').that_subscribes_to('xinetd::config') }

    it { is_expected.to contain_service('xinetd') }
    it { is_expected.to contain_package('xinetd').with_ensure('latest') }

    it { is_expected.to contain_package('xinetd').that_comes_before('Service[xinetd]') }
    it { is_expected.to contain_package('xinetd').that_comes_before('File[/etc/xinetd.conf]') }
    it { is_expected.to contain_package('xinetd').that_comes_before('File[/etc/xinetd.d]') }
  end

  it do
    is_expected.to contain_file('/etc/xinetd.conf').with({
      'owner' => 'root',
      'group' => 'root',
      'mode'  => '0600',
    })
  end

  it do
    is_expected.to contain_file('/etc/xinetd.d').with({
      'ensure'  => 'directory',
      'owner'   => 'root',
      'group'   => 'root',
      'mode'    => '0640',
      'recurse' => 'true'
    })
  end
#
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

        context "xinetd without any parameters" do
          let(:params) {{ }}
          it_behaves_like "xinetd"
          # it { is_expected.to contain_class('xinetd').with_client_nets( ['127.0.0.1/32']) }
        end

        # context "dummy class with firewall enabled" do
        #   let(:params) {{
        #     :client_nets     => ['10.0.2.0/24'],
        #     :tcp_listen_port => '1234',
        #     :enable_firewall => true,
        #   }}
        #   ###it_behaves_like "a structured module"
        #   it { is_expected.to contain_class('dummy::config::firewall') }
        #
        #   it { is_expected.to contain_class('dummy::config::firewall').that_comes_before('dummy::service') }
        #   it { is_expected.to create_iptables__add_tcp_stateful_listen('allow_dummy_tcp_connections').with_dports('1234') }
        # end

      end
    end
  end

  # context 'unsupported operating system' do
  #   describe 'dummy class without any parameters on Solaris/Nexenta' do
  #     let(:facts) {{
  #       :osfamily        => 'Solaris',
  #       :operatingsystem => 'Nexenta',
  #     }}
  #
  #     it { expect { is_expected.to contain_package('xinetd') }.to raise_error(Puppet::Error, /Nexenta not supported/) }
  #   end
  # end
end
