#!/bin/bash
##################
# WARNING! This example script may not work as you expect on your system.  
# You are responsible for understanding and modifying this script as well
# as ensuring that it correctly does what you wish and doesn't do anything
# else to your system!  This is merely an example to show methods of how
# a parallelized backup might be done -- You, not I, are responsible for
# anything you put on your own system!
##################
# This script runs a parallelized tar backup to four different tape drives.
# It can be easily modified to do other parallel activities.
# It appends some information to history files retained in /tmp
#    but overlays the actual log files created by the tar jobs.
# The locations of various programs are based on my SuSE system... 
#    You might want to verify the locations of sleep, tar, wc, bash, echo, ls
# If your tape device names aren't in /dev/st# format, change them below...
# The home page for this script along with the documentation and an overview
# is available at http://librenix.com/?inode=6383 
# -Ray Yeargin, April 9, 2005
##################

cd /

# shutdown any servcies that must be down during the backup
#/etc/init.d oracle stop
# wait for above services to shutdown if necessary, or just sleep...
#/bin/sleep 180


##################
# create header label and trailer files.  You might consider adding additional
# information to the header files so tapes will be more easily identified.
# The trailer files (/tmp/zzzz.#) are only for verification that the backup
# completed.

/bin/echo `/bin/date` > /tmp/date.0
/bin/echo `/bin/date` > /tmp/date.1
/bin/echo `/bin/date` > /tmp/date.2
/bin/echo `/bin/date` > /tmp/date.3

### and create trailer files...

/bin/echo `/bin/date` > /tmp/zzzz.0
/bin/echo `/bin/date` > /tmp/zzzz.1
/bin/echo `/bin/date` > /tmp/zzzz.2
/bin/echo `/bin/date` > /tmp/zzzz.3


##################
# run all four tars in background, with label first, directories to be backed
# up next, and the trailer files last...

/bin/tar cvf /dev/st0 /tmp/date.0 ./dir1 ./dir2 /tmp/zzzz.0> ./tmp/tar.0.log 2>&1& 
TASK0=$!

###

/bin/tar cvf /dev/st1 /tmp/date.1 ./dir3 ./dir4 /tmp/zzzz.1> ./tmp/tar.1.log 2>&1& 
TASK1=$!

###

/bin/tar cvf /dev/st2 /tmp/date.2 ./dir5 ./dir6 /tmp/zzzz.2> ./tmp/tar.2.log 2>&1& 
TASK2=$!

###

/bin/tar cvf /dev/st3 /tmp/date.3 ./dir7 ./dir8 /tmp/zzzz.3> ./tmp/tar.3.log 2>&1& 
TASK3=$!

##################
# wait for the completion of all four tars...

wait $TASK0
wait $TASK1
wait $TASK2
wait $TASK3

##################
# append a little summary information to a log file... you might want 
# to move the *.history files to a permanent location

/bin/echo "*********** ---"`/bin/date`"--- ***********">>/tmp/tar.0.history
/bin/ls -l /tmp/tar.0.log >> /tmp/tar.0.history
/usr/bin/wc -l /tmp/tar.0.log >> /tmp/tar.0.history

###

/bin/echo "*********** ---"`/bin/date`"--- ***********">>/tmp/tar.1.history
/bin/ls -l /tmp/tar.1.log >> /tmp/tar.1.history
/usr/bin/wc -l /tmp/tar.1.log >> /tmp/tar.1.history

###

/bin/echo "*********** ---"`/bin/date`"--- ***********">>/tmp/tar.2.history
/bin/ls -l /tmp/tar.2.log >> /tmp/tar.2.history
/usr/bin/wc -l /tmp/tar.2.log >> /tmp/tar.2.history

###

/bin/echo "*********** ---"`/bin/date`"--- ***********">>/tmp/tar.3.history
/bin/ls -l /tmp/tar.3.log >> /tmp/tar.3.history
/usr/bin/wc -l /tmp/tar.3.log >> /tmp/tar.3.history

##################
# restart any services that were brought down for the backup
#/etc/init.d oracle start
##################
