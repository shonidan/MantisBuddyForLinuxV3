#!/bin/bash

adb_port="5555"
msgTitle="MantisBuddyForLinuxV3"
dirPath="/sdcard/Android/data/app.mantispro.gamepad/files"

adb kill-server
adb disconnect

BTN_RETURNED=""

detect() {
    adb devices | sed -n '2p' > output.txt | sed -n '1p' output.txt > output.txt
    statusDevice=$(awk 'NR==1{print $NF}' output.txt)
    echo $statusDevice
    if [ "$statusDevice" = "unauthorized" ]
    then phoneUnauthorized
        return
    fi

    if [ -z $statusDevice ]
    then phoneNotFound
        return
    fi

    if [ "$statusDevice" = "device" ]; then
        inject
        return
    fi
}

inject() {
    adb shell find "$dirPath/buddyNew.sh"

    if [ "$?" -eq 1 ]; then
        titleStr="Please Launch App 'Mantis Gamepad Pro' on your Device and click Retry."
        btnReturned "$titleStr" inject
    else
        success_msg="Activation Complete!!\nPlease Launch 'Mantis Gamepad Pro', then open MantisBuddy Screen and check if Activated. If Activation fails after Unplugging, please run GamepadProWifiBuddy.command."
        adb shell sh "$dirPath/buddyNew.sh"
        zenity --info --title="MantisBuddy Activation Tool" --text="$success_msg" --ok-label=Ok
        rm -r output.txt
    fi
    exit
}

phoneNotFound() {
    titleStr="Android Device Not Found!! \n\n1. Make sure your devices's USB Debugging is On and unlock; \n2. Reconnect your phone to PC via USB cable\n3. Click Retry."
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
    rm -r output.txt
    then exit
    else return
    fi
}

detect
