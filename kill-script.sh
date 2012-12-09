#!/bin/sh

low_bat_pid=`pgrep low-bat.sh`
if [ -z $low_bat_pid ]
then
    echo "Low Battery Reminder is not running."
else
    kill $low_bat_pid
    echo "Low Battery Reminder terminated."
fi
