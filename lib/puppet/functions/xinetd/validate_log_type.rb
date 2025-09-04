# Perform validation on the log_type variable, as described in
# the man page of xinetd.conf(5)
Puppet::Functions.create_function(:'xinetd::validate_log_type') do
  # @param log_type
  #   Log specification for xinetd.conf log_type variable
  #
  # @return true upon validation success
  # @raise upon validation failure

  dispatch :validate_log_type do
    required_param 'String', :log_type
  end

  def validate_log_type(log_type)
    log_args = log_type.split
    if log_args[0] == 'SYSLOG'
      unless (log_args.length == 2) || (log_args.length == 3)
        raise("validate_log_type(): Error, SYSLOG type expects 1 or 2 parameters. Got '#{log_args.length - 1}'.")
      end
      unless ['daemon', 'auth', 'authpriv', 'user', 'mail', 'lpr', 'news', 'uucp', 'ftp',
              'local0', 'local1', 'local2', 'local3', 'local4', 'local5', 'local6', 'local7'].include? log_args[1]
        raise("validate_log_type(): Error, syslog_facility not recognized. Refer to xinetd.conf man page. Got '#{log_args[1]}'.")
      end
      if (log_args.length == 3) && !['emerg', 'alert', 'crit', 'err', 'warning', 'notice', 'info', 'debug'].include?(log_args[2])
        raise("validate_log_type(): Error, syslog_level not recognized.  Refer to xinetd.conf man page. Got '#{log_args[2]}'.")
      end
    elsif log_args[0] == 'FILE'
      unless log_args.length > 1
        raise('validate_log_type(): Error, FILE type requires at least 1 parameter')
      end
      # TODO: Validate the parameters
      # 1st param = fully qualified path for log file
      # 2nd param = optional soft limit
      # 3rd param = optional hard limit
    else
      raise("validate_log_type(): Error, log_type expected to be SYSLOG or FILE. Got '#{log_args[0]}'.")
    end
    true
  end
end
