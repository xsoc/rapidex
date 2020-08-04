# Rapid Exfil
The goals of this project:
- Grab as much data as possible as quickly as possible from a Windows machine
- Dead simple batch file that anyone can modify
- No admin privileges
- Zero dependencies
- Run off a usb stick

## How to use
1. Ask permission (hoping for forgiveness instead may result in prison)
2. Copy `RapidEx.cmd` to a USB drive
3. Insert USB into target Windows machine
4. Double-click `RapidEx.cmd` in Explorer (or single-click if the system was configured by masochists)
5. Intel will be saved in `%COMPUTERNAME%` on the USB drive.
