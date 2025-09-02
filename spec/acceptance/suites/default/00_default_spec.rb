require 'spec_helper_acceptance'

test_name 'xinetd'

describe 'xinetd' do
  hosts.each do |_host|
    let(:manifest) do
      <<~EOF
        xinetd::service { 'uptime':
          server         => '/usr/bin/uptime',
          port           => 12345,
          protocol       => 'tcp',
          user           => 'nobody',
          x_type         => 'UNLISTED',
          x_wait         => 'no',
          socket_type    => 'stream',
          trusted_nets   => ['ALL'],
        }
      EOF
    end
    let(:hieradata) do
      {
        'iptables::ports' => { 22 => { 'proto' => 'tcp', 'trusted_nets' => ['ALL'] } },
        'simp_options::firewall' => true,
      }
    end

    hosts.each do |host|
      context "on #{host}" do
        it 'applies with no errors' do
          set_hieradata_on(host, hieradata)
          apply_manifest_on(host, manifest)
        end

        it 'is idempotent' do
          apply_manifest_on(host, manifest, catch_changes: true)
        end

        it 'has set up an uptime service' do
          result = on(
            hosts.find { |h| h != host },
            %(nc -i 1 -w 1 #{host.ip} 12345),
            accept_all_exit_codes: true,
          ).stdout.strip

          expect(result).not_to be_empty
        end
      end
    end
  end
end
