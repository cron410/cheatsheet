sc config netlogon start= auto
net stop w32time
w32tm /unregister
w32tm /register
sc config w32time type= own
net start w32time
w32tm /config /syncfromflags:domhier /update /reliable:no
net stop w32time
net start w32time
