## What is Low Battery Reminder? ##

Low Battery Reminder is a small tool which notifies you to plug-in your charger.
It runs as a daemon in the background,  plays a warning sound and displays a
popup as soon as the battery level falls below the defined threshold. It will
increase the sound volume to 90%, play the warning and restore the original
sound volume. It also works if the sound is muted. It features a male as well as
a female voice.

## Pre-requisites ##

Make sure that you have acpi, vlc, alsa-utils and libnotify installed.

## Usage ##

Set the threshold value and voice preference by modifying the variables
in settings.conf. You can run the script directly or put it under the startup
applications and it should work just fine.
    
    Default threshold is 25%.
    Default voice preference is female (Obviously! ;-)).

To stop the script, simply kill it from the terminal. You can also use the
kill-script.sh provided. It basically does the same thing.

## Contact ##

In case of any queries/suggestions/bugs please contact:
Gaurav Jain (grvmjain@gmail.com)

## License ##

   Do whatever you want to with this script. Covered under GNU-GPL v3.0.
   NO WARRANTY IS PROVIDED.
   More info at http://www.gnu.org/licenses/gpl.txt
