sc config netlogon start= auto
net stop w32time
w32tm /unregister
w32tm /register
sc config w32time type= own
net start w32time
W32tm /config /manualpeerlist:pool.ntp.org,0x1 /syncfromflags:manual /reliable:yes /update
w32tm /resync /rediscover
net stop w32time
net start w32time
w32tm /resync /rediscover
