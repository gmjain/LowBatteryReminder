#!/bin/sh

###############################################################################
# Low Battery Reminder                                                        #
# Author:  Gaurav Jain                                                        #
# Contact: grvmjain@gmail.com                                                 #
#                                                                             #
# Pre-requisites: acpi, vlc, alsa-utils, libnotify                            #
#                                                                             #
# About Program: This script runs in the background as a daemon and plays     #
#                a warning sound and displays a popup as soon as the          #
#                battery level falls below the defined threshold.             #
#                                                                             #
#                It will increase the sound volume to 90%, play the           #
#                warning and restore the original sound volume. It also       #
#                works if the sound is muted.                                 #
#                                                                             #
#                Add this script to the startup applications and it will      #
#                work just fine.                                              #
#                                                                             #
#                Default voice:     female (Acceptable value: male, female)   #
#                Default threshold: 25%    (Acceptable value: 0-100%)         #
#                                                                             #
#                To change these values, edit the variables at the beginning  #
#                of the script.                                               #
#                                                                             #
#                To stop the script, simply kill it from the terminal.        #
#                You can also use the kill-script.sh provided. It does the    #
#                same thing.                                                  #
#                                                                             #
#                Make sure that the 4 files are always present in the folder: #
#                warning_male.wav,                                            #
#                warning_female.wav,                                          #
#                README & the script itself.                                  #
#                                                                             #
# License: Do whatever you want to with this script.                          #
#          NO WARRANTY IS PROVIDED.                                           #
#          More info at http://www.gnu.org/licenses/gpl.txt                   #
###############################################################################

(
# No error checking for the following 2 variables.
preference=female    # preference can be male or female.
threshold=25         # threshold can be any percentage value you want to set.

# Do NOT modify these 3 variables.
path_to_script=`readlink -f $0`
dir_to_script=`dirname $path_to_script`
path_to_wav="$dir_to_script/warning_$preference.wav"

while :
do
    acpi_out=`acpi -b`
    bat_remaining=`echo $acpi_out | awk -F'[ %]' '{print $4}'`

    # power_stat will store whether battery is [C]harging or [D]ischarging.
    power_stat=`echo $acpi_out | awk '{print $3}' | cut -c1`
    if [ "$power_stat" = 'D' ]
    then
        if [ $bat_remaining -lt $threshold ]
        then
            # Extract current sound volume percentage or whether it is muted.
            amixer_out=`amixer get Master | grep Mono:`
            amixer_level=`echo $amixer_out | awk -F"[][]" '{print $2}'`
            amixer_status=`echo $amixer_out | awk -F"[][]" '{print $6}'`

            # Set the sound volume to 100%
            amixer set Master 90% on
            amixer set Headphone 100% on

            # Send Gnome-Notification warning.
            notify-send -u critical "Battery Remaining: $bat_remaining%"

            # Play warning sound.
            cvlc $path_to_wav&
            sleep 4

            # Kill the warning sound vlc process.
            kill `ps aux | grep warning_$preference |
                  grep vlc | awk '{print $2}'`

            # Restore the extracted sound volume and status.
            amixer set Master $amixer_level $amixer_status
            amixer set Headphone $amixer_status
        fi
        sleep 120    # Sleep for 2 minutes if battery-low and still discharging.
    else
        sleep 300    # Sleep for 5 minutes if charging before checking again.
    fi
done
) &

echo "Battery Drain Reminder started in background."
