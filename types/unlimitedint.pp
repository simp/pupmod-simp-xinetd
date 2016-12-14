#TODO rlimit_as regex should accept K or M qualifiers
type Xinetd::UnlimitedInt = Variant[Integer,Pattern[/(^\d+$|UNLIMITED)/]]
