#!/bin/sh

low_bat_pid=`ps aux | grep low-bat.sh | grep -v grep | awk '{print $2}'`
if [ -z $low_bat_pid ]
then
    echo "Low Battery Reminder is already stopped."
else
    kill $low_bat_pid
    echo "Low Battery Reminder killed."
fi
