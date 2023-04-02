#!/bin/bash

adb_port="5555"
msgTitle="MantisBuddyForLinuxV3"
dirPath="/sdcard/Android/data/app.mantispro.gamepad/files"

adb kill-server
adb disconnect

BTN_RETURNED=""

detect() {
    adb devices | sed -n '2p' > /tmp/mantis_activate | sed -n '1p' /tmp/mantis_activate > /tmp/mantis_activate
    statusDevice=$(awk 'NR==1{print $NF}' /tmp/mantis_activate)
    echo $statusDevice
    if [ "$statusDevice" = "unauthorized" ]
        then phoneUnauthorized
        return
    fi

    if [ -z $statusDevice ]
        then phoneNotFound
        return
    fi

    if [ "$statusDevice" = "device" ]
        then inject
        return
    fi
}

inject() {
    adb shell find "$dirPath/buddyNew.sh"

    if [ "$?" -eq 1 ]; then
        titleStr="Please Launch App 'Mantis Gamepad Pro' on your Device and click Retry."
        btnReturned "$titleStr" inject
    else
        success_msg="Activation Complete!!\nPlease Launch 'Mantis Gamepad Pro', then open MantisBuddy Screen and check if Activated. If Activation fails after Unplugging, please run ActivateBuddy.sh"
        adb shell sh "$dirPath/buddyNew.sh"
        zenity --info --title="MantisBuddy Activation Tool" --text="$success_msg" --ok-label=Ok
        rm -r /tmp/mantis_activate
    fi
    exit
}

phoneNotFound() {
    titleStr="Android Device Not Found!! \n\n1. Make sure unlock your device an USB USB Debugging is On; \n2. Reconnect your phone to PC via USB cable\n3. Click Retry."
    btnReturned "$titleStr" detect
}

phoneUnauthorized() {
    titleStr="Tap Allow button on device's USB Debugging popup window and click Retry. \n \n If popup not shown, click Cancel and run me again.."
    btnReturned "$titleStr" detect
}

btnReturned() {
    BTN_RETURNED=$(zenity --question --title=$msgTitle --text="$1" --ok-label=Retry --cancel-label=Quit)
    OUTPUT=$?
    if [ "$OUTPUT" -eq 0 ]
    then detect
    elif [ "$OUTPUT" -eq 1 ]
    rm -r /tmp/mantis_activate
    then exit
    else return
    fi
}

detect
