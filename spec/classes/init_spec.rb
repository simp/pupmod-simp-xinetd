require 'spec_helper'

describe 'xinetd' do

  base_facts = {
    :interfaces => 'eth0'
  }
  let(:facts){base_facts}

  it { should create_class('xinetd') }
  it { should contain_package('xinetd').that_comes_before('Service[xinetd]') }
  it { should contain_package('xinetd').that_comes_before('File[/etc/xinetd.conf]') }
  it { should contain_package('xinetd').that_comes_before('File[/etc/xinetd.d]') }

  it do
    should contain_file('/etc/xinetd.conf').with({
      'owner' => 'root',
      'group' => 'root',
      'mode'  => '0600',
    })
  end

  it do
    should contain_file('/etc/xinetd.d').with({
      'ensure'  => 'directory',
      'owner'   => 'root',
      'group'   => 'root',
      'mode'    => '0640',
      'recurse' => 'true'
    })
  end
end
