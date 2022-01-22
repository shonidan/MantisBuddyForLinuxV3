#!/bin/bash
adb_port="5555"
msgTitle="MantisBuddy Activation Tool"
dirPath="/sdcard/Android/data/app.mantispro.gamepad/files"



DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"


adb kill-server
adb disconnect


function detect(){

    if [ `adb devices|grep "unauthorized"|wc -l` -ge 1 ]
    then phoneUnauthorized
         return
    fi

    $DIR/adb root
    if [ $? -eq 1 ]
    then phoneNotFound
         return
    fi

    if [ $? -eq 0 ]
    then inject
         return
    fi
}

function inject(){

    $DIR/adb shell find $dirPath/buddyNew.sh

    if [ $? -eq 1 ]
    then titleStr="Please Launch App 'Mantis Gamepad Pro' on your Device and click Retry."
         notify-send -t 0 "$titleStr"
         echo -e "$titleStr"

    else $DIR/adb shell sh $dirPath/buddyNew.sh
         succes_msg_1='🎮 Activation Complete!'
         succes_msg_2='Please Launch "Mantis Gamepad Pro", then open MantisBuddy Screen and check if Activated.\nIf Activation fails after Unplugging, please run ActivateBuddyWifi.sh.'
         notify-send -t 0 "$succes_msg_1" "$succes_msg_2"
         echo -e "$succes_msg_1,\n$succes_msg_2"
    fi
    exit

}

function phoneNotFound(){

    titleStr='Android Device Not Found!!'
    descriptionStr='Make sure your devices USB Debugging is On. Reconnect your phone to PC via USB cable and retry'
    echo -e "$titleStr,\n$descriptionStr"
    notify-send -t 0 "$titleStr" "$descriptionStr"

}

function phoneUnauthorized(){

    titleStr='Tap Allow button on device USB Debugging popup window and retry.'
    descriptionStr='If popup not shown, click Cancel and run me again..'
    echo -e "$titleStr,\n$descriptionStr"
    notify-send -t 0 "$titleStr" "$descriptionStr"

}

detect
