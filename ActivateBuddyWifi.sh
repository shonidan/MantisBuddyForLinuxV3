adb_port="5555"
msgTitle="MantisBuddy Activation Tool"
dirPath="/sdcard/Android/data/app.mantispro.gamepad/files"



DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"


adb kill-server
adb devices
adb disconnect


BTN_RETURNED=""

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


phoneIP=""

function inject(){

    $DIR/adb shell find $dirPath/buddyNew.sh

    if [ $? -eq 1 ]
    then titleStr="Please Launch App 'Mantis Gamepad Pro' on your Device and click Retry."
         btnReturned "$titleStr" inject
    else

        tryWifiConnect

        $DIR/adb -s $phoneIP:$adb_port shell sh $dirPath/buddyNew.sh

         succes_msg_1='Activation Complete!!'
         succes_msg_2='Please Launch "Mantis Gamepad Pro", then open MantisBuddy Screen and check if Activated.\nIf Activation fails after Unplugging, please run ActivateBuddyWifi.sh.'
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
         btnReturned "$titleStr" tryWifiConnect
    fi

    $DIR/adb tcpip $adb_port
    $DIR/adb connect $phoneIP:$adb_port

    return

}

function phoneNotFound(){


    titleStr="Android Device Not Found!! \n\n1. Make sure your devices's USB Debugging is On; \n2. Reconnect your phone to PC via USB cable\n3. Click Retry."

    btnReturned "$titleStr" detect

    return
}

function phoneUnauthorized(){

    titleStr="Tap Allow button on device's USB Debugging popup window and click Retry. \n \n If popup not shown, click Cancel and run me again.."

    btnReturned "$titleStr" detect

    return
}

detect
