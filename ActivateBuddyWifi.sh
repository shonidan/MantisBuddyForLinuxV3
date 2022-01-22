adb_port="5555"
msgTitle="MantisBuddy Activation Tool"
dirPath="/sdcard/Android/data/app.mantispro.gamepad/files"



DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"


adb kill-server
adb devices
adb disconnect

function detect(){

    if  [ `adb shell getprop ro.build.version.release` -le 10 ]
    then wirelessDebuggingAndroidCheck
        return
    fi

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


phoneIP=""

function inject(){

    $DIR/adb shell find $dirPath/buddyNew.sh

    if [ $? -eq 1 ]
    then titleStr="Please Launch App 'Mantis Gamepad Pro' on your Device and click Retry."
         echo -e "$titleStr"
         notify-send -t 0 "$titleStr"
    else

        tryWifiConnect

        $DIR/adb -s $phoneIP:$adb_port shell sh $dirPath/buddyNew.sh

         succes_msg_1='Activation Complete!!'
         succes_msg_2='Please Launch "Mantis Gamepad Pro", then open MantisBuddy Screen and check if Activated.\nIf Activation fails after Unplugging, please run ActivateBuddyWifi.sh.'
         echo -e "$succes_msg_1,\n$succes_msg_2"
         notify-send -t 0 "$succes_msg_1" "$succes_msg_2"
    fi
    exit

}

function tryWifiConnect(){
    adb disconnect >nul
    phoneIP=`adb shell ip addr|grep "wlan0"|grep "inet"`
    phoneIP=`echo ${phoneIP%/*}|cut -c 6-50`
    ping -c 3 $phoneIP

    if [ $? != 0 ]
    then titleStr="Failed, please ensure WIFI on your phone is connected and in the same LAN(local network) with your PC."
         echo -e "$titleStr"
         notify-send -t 0 "$titleStr"
    fi

    $DIR/adb tcpip $adb_port
    $DIR/adb connect $phoneIP:$adb_port

    return

}

function phoneNotFound(){

    titleStr='Android Device Not Found!!'
    descriptionStr='Make sure your devices USB Debugging is On. Reconnect your phone to PC via USB cable and retry.'
    echo -e "$titleStr,\n$descriptionStr"
    notify-send -t 0 "$titleStr" "$descriptionStr"

    return
}

function phoneUnauthorized(){

    titleStr='Tap Allow button on device USB Debugging popup window and retry.'
    descriptionStr='If popup not shown, click Cancel and run me again.'
    echo -e "$titleStr,\n$descriptionStr"
    notify-send -t 0 "$titleStr" "$descriptionStr"

    return
}

function wirelessDebuggingAndroidCheck(){

    titleStr="The android version don't support wireless debugging."
    echo -e "$titleStr"
    notify-send -t 0 "$titleStr"

    return
}

detect
