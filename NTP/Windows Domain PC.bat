sc config netlogon start= auto
net stop w32time
w32tm /unregister
w32tm /register
net start w32time
w32tm /config /syncfromflags:domhier /update /reliable:no
w32tm /resync /rediscover
net stop w32time
net start w32time
w32tm /resync /rediscover
