# Rapid Exfil
Proof of Concept - Gather intel on a target machine with physical access in seconds.

The goals of this project:
- Grab as much data as possible as quickly as possible from a Windows machine
- Dead simple batch file that anyone can modify
- No admin privileges
- Zero dependencies
- Run off a usb stick

## Usage
1. Ask permission (hoping for forgiveness instead may result in prison)
2. Copy `RapidEx.cmd` to a USB drive
3. Insert USB into target Windows machine
4. Double-click `RapidEx.cmd`
5. Intel will be saved in `%COMPUTERNAME%` on the USB drive.

## What data does it gather?
Here's a brief summary
- Wifi passwords
- Network devices
- List of installed / running programs
- List of users
- File associations
- Browser profiles including history, password files etc
- Full directory tree listings *(disabled by default for speed)*
- *and more, view the code to see it all*
