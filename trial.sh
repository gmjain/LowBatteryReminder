#!/bin/sh

dir1=`readlink -f $0`
dir2=`dirname $dir1`
dir=90%
echo $dir
cvlc ./warning_male.wav&
