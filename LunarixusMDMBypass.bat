@echo off

Title Lunarixus MDM Bypass Tool

color a 

echo Lunarixus MDM Bypass
echo Shout-out to that one sketch eBay guy for source code
echo 

deviceinfo.dll -k SerialNumber > info.log 2>&1

find /c "ERROR: No device found!" info.log > nul
    if %errorlevel% equ 1 goto notfound1
    echo Error occured.
    echo Device not connected. Connect and try again.
    echo.
    echo Possible Fix : Open iTunes and check if device is connected then try again.
    goto end
	
    :notfound1
    find /c "Could not connect to lockdownd" info.log > nul
    if %errorlevel% equ 1 goto verify
    echo Software cannot connect to device.
    echo Make sure the device gets detected in iTunes and try again.
    echo.
    echo Possible Fix : Connect the device in Recovery mode and restore it in iTunes. Then try again.
    goto end


    :verify
	
echo
echo
	
FOR /F "tokens=* USEBACKQ" %%F IN (`deviceinfo.dll -k SerialNumber`) DO (
SET Serial=%%F
)

FOR /F "tokens=* USEBACKQ" %%F IN (`deviceinfo.dll -k UniqueDeviceID`) DO (
SET UDID=%%F
)

FOR /F "tokens=* USEBACKQ" %%F IN (`deviceinfo.dll -k ProductType`) DO (
SET DeviceName=%%F
)

FOR /F "tokens=* USEBACKQ" %%F IN (`deviceinfo.dll -k ProductVersion`) DO (
SET ios=%%F
)


echo Device Connected: %DeviceName%         
echo iOS: %ios%
echo Serial: %Serial%
echo UDID: %UDID%
echo 
echo Please wait, bypassing...

libcon.dll -convert xml1 "ffe2017db9c5071adfa1c23d3769970f7524a9d4\Manifest.plist" >nul 2>&1

down.dll ed -L -u "//key[.='SerialNumber']/following-sibling::string[1]" -v %Serial% "ffe2017db9c5071adfa1c23d3769970f7524a9d4\Manifest.plist" >nul 2>&1

down.dll ed -L -u "//key[.='UniqueDeviceID']/following-sibling::string[1]" -v %UDID% "ffe2017db9c5071adfa1c23d3769970f7524a9d4\Manifest.plist" >nul 2>&1

libcon.dll -convert binary1 "ffe2017db9c5071adfa1c23d3769970f7524a9d4\Manifest.plist" >nul 2>&1

sys.temp.dll -s ffe2017db9c5071adfa1c23d3769970f7524a9d4 restore --system --settings --skip-apps --no-reboot "%temp%" > test.log


echo Device is rebooting, once it has rebooted MDM should be bypassed.

finish.dll restart > nul

echo ------------------------------
echo Twitter: @TheLunarixus
echo Telegram: @Lunarixus
echo GitHub: Lunarixus
echo ------------------------------


del /f "info.log" >nul 2>&1

pause
