#!/bin/sh

###############################################################################
# Low Battery Reminder                                                        #
# Author:  Gaurav Jain                                                        #
# Contact: grvmjain@gmail.com                                                 #
#                                                                             #
# Pre-requisites: acpi, alsa-utils, libnotify                                 #
#                                                                             #
# About: Refer the README file                                                #
#                                                                             #
# License: Do whatever you want to with this script.                          #
#          NO WARRANTY IS PROVIDED.                                           #
#          More info at http://www.gnu.org/licenses/gpl.txt                   #
###############################################################################

(
command -v acpi >/dev/null 2>&1 ||
{ echo >&2 "'acpi' is not installed. Aborting."; exit 1; }

# Do NOT modify these 3 variables.
path_to_script=`readlink -f $0`
dir_to_script=`dirname $path_to_script`

# Sourcing the settings file.
. $dir_to_script/settings.conf

path_to_wav="$dir_to_script/warning_$preference.wav"

while :
do
    acpi_out=`acpi -b`

    # power_stat will store whether battery is [C]harging or [D]ischarging.
    power_stat=`echo $acpi_out | awk '{print $3}' | cut -c1`
    if [ "$power_stat" = 'D' ]
    then
        bat_remaining=`echo $acpi_out | awk -F'[ %]' '{print $4}'`
        if [ $bat_remaining -lt $threshold ]
        then
            # Extract current sound volume percentage or whether it is muted.
            amixer_out=`amixer get Master | grep Mono:`
            amixer_level=`echo $amixer_out | awk -F"[][]" '{print $2}'`
            amixer_status=`echo $amixer_out | awk -F"[][]" '{print $6}'`

            # Set the sound volume to 100%
            amixer set Master 90% unmute > /dev/null
            amixer set Headphone unmute > /dev/null
            amixer set Speaker unmute > /dev/null
            amixer set PCM 100% unmute > /dev/null

            # Send Gnome-Notification warning.
            notify-send -u critical "Battery Remaining: $bat_remaining%"

            # Play warning sound.
            aplay -q $path_to_wav

            # Restore the extracted sound volume and status.
            amixer set Master $amixer_level $amixer_status > /dev/null
        fi
        sleep 120    # Sleep for 2 minutes if battery-low and still discharging.
    else
        sleep 300    # Sleep for 5 minutes if charging before checking again.
    fi
done
) &

echo "Battery Drain Reminder started in background."
