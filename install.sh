#!/bin/bash
ActivateBuddy="ActivateBuddy.sh"
ActivateBuddyWifi="ActivateBuddyWifi.sh"
chmod +x "$ActivateBuddy"
chmod +x "$ActivateBuddyWifi"
sudo cp ActivateBuddy.sh /usr/bin/ActivateBuddy
sudo cp ActivateBuddyWifi.sh /usr/bin/ActivateBuddyWifi
echo -e "Installation succesfully"
