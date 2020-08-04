# Rapid Exfil
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
4. Double-click `RapidEx.cmd` in Explorer (or single-click if the system was configured by masochists)
5. Intel will be saved in `%COMPUTERNAME%` on the USB drive.

In order to keep the code as clean and hackable by noobs as possible, there are no command line parameters, which can reduce readbility.
If you want to do something specific, or enable something that is disabled by default, *EDIT THE CODE, IT'S DESIGNED TO BE EASY AF*.

## What data does it gather?
Here's a brief summary
- Wifi passwords
- Network devices
- List of installed / running programs
- List of users
- File associations
- Full directory tree listings *(disabled by default for speed)*
- Browser profiles *(disabled by default for speed)*

## How fast is it?
It depends.

With default settings, it runs in about 3 seconds on my machine. If I enable everything, it will take around 5 minutes.
