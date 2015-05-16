module Puppet::Parser::Functions
  newfunction(:validate_log_type, :doc => <<-'ENDDOC') do |args|
    Perform validation on the log_type variable, as described in
    the man page of xinetd.conf(5)

  ENDDOC

  unless args.length == 1
    raise Puppet::ParseError, ("validate_log_type(): expects a single string. Got '#{args.length} strings.'")
  end

  arg_v = args[0].split
  unless arg_v.length == 2 or arg_v.length == 3
    raise Puppet::ParseError, ("validate_log_type(): expects two or three arguments.  Got '#{arg_v.length}'")
  end
  if arg_v[0] == 'SYSLOG'
    if not ['daemon', 'auth', 'authpriv', 'user', 'mail', 'lpr', 'news', 'uucp', 'ftp', 'local0-7'].include? arg_v[1]
      raise Puppet::ParseError, ("validate_log_type(): syslog_facility not recognized.  Refer to xinted.conf man page.  Got '#{arg_v[1]}'")
    end
    if arg_v.length == 3 and not ['emerg', 'alert', 'crit', 'err', 'warning', 'notice', 'info', 'debug'].include? arg_v[2]
      raise Puppet::ParseError, ("validate_log_type(): syslog_level not recognized.  Refer to xinted.conf man page.  Got '#{arg_v[2]}'")
    end
  elsif arg_v[0] == 'FILE'
    # Optional validation
  else
    raise Puppet::ParseError, ("validate_log_type(): log_type expected to be SYSLOG or FILE.  Got '#{arg_v[0]}'")
  end
  end
end
