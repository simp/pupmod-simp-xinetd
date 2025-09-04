require 'spec_helper'

describe 'xinetd::validate_log_type' do
  context 'valid 1-parameter SYSLOG specification' do
    ['daemon', 'auth', 'authpriv', 'user', 'mail', 'lpr', 'news', 'uucp', 'ftp',
     'local0', 'local1', 'local2', 'local3', 'local4', 'local5', 'local6',
     'local7'].each do |facility|
      it "validates with valid facility #{facility}" do
        is_expected.to run.with_params("SYSLOG #{facility}")
      end
    end
  end

  context 'valid 2-parameter SYSLOG specification' do
    ['emerg', 'alert', 'crit', 'err', 'warning', 'notice', 'info', 'debug'].each do |level|
      it "validates with valid level #{level}" do
        is_expected.to run.with_params("SYSLOG authpriv #{level}")
      end
    end
  end

  context 'validates any FILE specification' do
    it 'validates with 1 parameter' do
      is_expected.to run.with_params('FILE /some/log/file')
    end
  end

  context 'invalid log specification' do
    it 'rejects array' do
      is_expected.to run.with_params('SYSLOG', 'auth', 'warning').and_raise_error(ArgumentError)
    end

    it 'rejects no-parameter SYSLOG log specification' do
      is_expected.to run.with_params('SYSLOG').and_raise_error(
        %r{SYSLOG type expects 1 or 2 parameters. Got '0'.},
      )
    end

    it 'rejects no-parameter FILE log specification' do
      is_expected.to run.with_params('FILE').and_raise_error(
        %r{FILE type requires at least 1 parameter},
      )
    end

    it 'rejects 4-parameter log specification' do
      is_expected.to run.with_params('SYSLOG auth warning info').and_raise_error(
        %r{SYSLOG type expects 1 or 2 parameters. Got '3'.},
      )
    end

    it 'rejects invalid log type' do
      is_expected.to run.with_params('RSYSLOG auth warning').and_raise_error(
        %r{log_type expected to be SYSLOG or FILE. Got 'RSYSLOG'.},
      )
    end

    it 'rejects invalid syslog facility' do
      is_expected.to run.with_params('SYSLOG oops').and_raise_error(
        %r{facility not recognized.* Got 'oops'.},
      )
    end

    it 'rejects invalid syslog level' do
      is_expected.to run.with_params('SYSLOG local6 oops').and_raise_error(
       %r{level not recognized.* Got 'oops'.},
     )
    end
  end
end
