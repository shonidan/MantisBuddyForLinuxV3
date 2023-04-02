# MantisBuddyForLinuxV3

MantisBuddyForLinuxV3 is a script modified from the original [source](https://mantispro.app/buddy/) for linux.

## Steps

⚠️ You must have adb installed on your linux distribution.

1. Make sure USB Debugging is enabled on your device. (Needs to be done only once).
   * Go to Settings -> About -> **Repeatedly Tap on Build Number**(or MIUI Version) until it displays you’re a developer.
   * Now Go one step back and Open Developer Settings. Generally found inside System or Additional Settings.
   * Turn on USB Debugging.
   * Turn on USB Debugging(Secure Settings)/Disable Permission monitoring(at the very bottom). Depending on what the setting is named on your device.

2. Now Connect your Device to your Linux computer via USB Cable.
3. Clone the repository and enter into the folder.
```
git clone https://github.com/C0MODIN/MantisBuddyForLinuxV3.git
cd MantisBuddyForLinuxV3
```
4. Assign execute permission.
```
chmod +x mantis_activate.sh
```

## Usage

Run the script.
```
./mantis_activate.sh
```

⚠️ **Note:** If and when a popup window prompts on your device, tap **Allow/Trust/OK** button along with **Allow always for this Computer**.

## Install option

1. Assign execute permission.
```
chmod +x install.sh
```
2. Run the script.
```
./install.sh
```
3. Execute the system command in your terminal.
```bash
mantis_activate
```
