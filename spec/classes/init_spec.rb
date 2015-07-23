require 'spec_helper'

describe 'xinetd' do

  context 'supported operating systems' do
    on_supported_os.each do |os, facts|
      let(:facts) do
        facts
      end

      context "on #{os}" do
        context "xinetd without any parameters" do
          let(:params) {{ }}

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

        end
      end

    end
  end

  context 'unsupported operating system' do
    describe 'xinetd without any parameters on Solaris/Nexenta' do
      let(:facts) {{
        :osfamily        => 'Solaris',
        :operatingsystem => 'Nexenta',
        :interfaces      => 'eth0',
      }}

      it { expect { is_expected.to contain_package('xinetd') }.to raise_error(Puppet::Error, /Nexenta not supported/) }
    end
  end
end
