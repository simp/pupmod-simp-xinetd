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
