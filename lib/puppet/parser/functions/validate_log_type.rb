module Puppet::Parser::Functions
  newfunction(:validate_log_type, :doc => <<-'ENDDOC') do |args|
    Perform validation on the log_type variable, as described in
    the man page of xinetd.conf(5)

  ENDDOC

   unless args.length == 1
     raise Puppet::ParseError, ("validate_log_type(): expects a single string. Got '#{args.length}'.")
   end

   arg_v = args[0].split
   if arg_v[0] == 'SYSLOG'
     unless arg_v.length == 2 or arg_v.length == 3
       raise Puppet::ParseError, ("validate_log_type(): SYSLOG type expects one or two parameters. Got '#{arg_v.length-1}'.")
     end
     if not ['daemon', 'auth', 'authpriv', 'user', 'mail', 'lpr', 'news', 'uucp', 'ftp',
         'local0','local1', 'local2', 'local3', 'local4', 'local5', 'local6', 'local7'].include? arg_v[1]
       raise Puppet::ParseError, ("validate_log_type(): syslog_facility not recognized. Refer to xinetd.conf man page. Got '#{arg_v[1]}'.")
     end
     if arg_v.length == 3 and not ['emerg', 'alert', 'crit', 'err', 'warning', 'notice', 'info', 'debug'].include? arg_v[2]
       raise Puppet::ParseError, ("validate_log_type(): syslog_level not recognized.  Refer to xinetd.conf man page. Got '#{arg_v[2]}'.")
     end
   elsif arg_v[0] == 'FILE'
     # Unimplemented validation; can have 1-3 parameters
   else
     raise Puppet::ParseError, ("validate_log_type(): log_type expected to be SYSLOG or FILE. Got '#{arg_v[0]}'.")
   end
 end
end
