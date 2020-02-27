# Valid deny_time values from xinetd.conf(5)
type Xinetd::DenyTime = Pattern[/^((\d+)|(FOREVER|NEVER))$/]
