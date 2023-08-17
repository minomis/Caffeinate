#!/bin/bash

################################################################################
# Caffeinate - A simple GUI to start/stop the caffeinate service.
# Created by Simon Im - 16th August 2023
# Version 2.0
################################################################################

# set icon directory
current_directory="$(pwd)"
icon="$current_directory/AppIcon.icns"

function DIALOG_GENERIC_ERROR() {
/usr/bin/osascript<<END
display dialog "
Caffeinate has run into an error and will now quit" giving up after 300 \
buttons {"OK"} default button "OK" \
with title "Caffeinate"
END
exit 0
}

function DIALOG_START_STOP() {
/usr/bin/osascript<<END
set QUESTION to \
display dialog "
Caffeinate Status: $SERVICE_STATUS" giving up after 9999999 \
with icon POSIX file "$icon" \
buttons {"Start", "Stop", "Exit"} default button "Start" \
with title "Caffeinate"

if button returned of QUESTION is "Stop" then
	do shell script "killall caffeinate"
else if button returned of QUESTION is "Exit" then
	do shell script "killall caffeinate ; killall Caffeinate"
else if button returned of QUESTION is "Start" then
    do shell script "killall caffeinate ; /usr/bin/caffeinate -dimsu & killall osascript"
end if
END
}

function DIALOG_ON() {
/usr/bin/osascript<<END
set QUESTION to \
display dialog "
Caffeinate has started" giving up after 5 \
with icon POSIX file "$icon" \
buttons {"OK"} default button "OK" \
with title "Caffeinate"
END
}

function DIALOG_OFF() {
/usr/bin/osascript<<END
set QUESTION to \
display dialog "
Caffeinate has stopped" giving up after 5 \
with icon POSIX file "$icon" \
buttons {"OK"} default button "OK" \
with title "Caffeinate"
END
}

function CHECK_STATUS() {
    if pgrep caffeinate ; [[ "$?" == "0" ]] ; then
        SERVICE_STATUS='ON'
    else
        SERVICE_STATUS='OFF'
    fi
}

############ START ############
    CHECK_STATUS
    DIALOG_START_STOP
    CHECK_STATUS
    if [[ "$SERVICE_STATUS" == "ON" ]] ; then
        DIALOG_ON
    elif [[ "$SERVICE_STATUS" == "OFF" ]] ; then
        DIALOG_OFF
    else
        DIALOG_GENERIC_ERROR
    fi
############ END ############
