# Valid access_times from xinetd.conf(5)
type Xinetd::AccessTimes = Pattern[/^([01]?[0-9]|2[0-3]):[0-5][0-9]-([01]?[0-9]|2[0-3]):[0-5][0-9]$/]
