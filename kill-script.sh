#!/bin/sh

kill `ps aux | grep low-bat.sh | grep -v grep | awk '{print $2}'`
