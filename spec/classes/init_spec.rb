require 'spec_helper'

describe 'xinetd' do

  base_facts = {
    :interfaces => 'eth0'
  }
  let(:facts){base_facts}

  it { is_expected.to create_class('xinetd') }
  it { is_expected.to contain_package('xinetd').that_comes_before('Service[xinetd]') }
  it { is_expected.to contain_package('xinetd').that_comes_before('File[/etc/xinetd.conf]') }
  it { is_expected.to contain_package('xinetd').that_comes_before('File[/etc/xinetd.d]') }

  it do
    is_expected.to contain_file('/etc/xinetd.conf').with({
      'owner' => 'root',
      'group' => 'root',
      'mode' => '0600',
    })
  end

  it do
    is_expected.to contain_file('/etc/xinetd.d').with({
      'ensure' => 'directory',
      'owner' => 'root',
      'group' => 'root',
      'mode' => '0640',
      'recurse' => 'true'
    })
  end
end
