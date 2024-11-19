setlocal
if NOT "%UE_SDKS_ROOT%"=="" (call %UE_SDKS_ROOT%\HostWin64\Android\SetupEnvironmentVars.bat)
set ANDROIDHOME=%ANDROID_HOME%
if "%ANDROIDHOME%"=="" set ANDROIDHOME=E:/Epic/Android/android-sdk
set ADB=%ANDROIDHOME%\platform-tools\adb.exe
set AFS=.\win-x64\UnrealAndroidFileTool.exe
set DEVICE=
if not "%1"=="" set DEVICE=-s %1
for /f "delims=" %%A in ('%ADB% %DEVICE% shell "echo $EXTERNAL_STORAGE"') do @set STORAGE=%%A
@echo.
@echo Uninstalling existing application. Failures here can almost always be ignored.
%ADB% %DEVICE% uninstall com.YourCompany.Chapter1
@echo.
@echo Installing existing application. Failures here indicate a problem with the device (connection or storage permissions) and are fatal.
%ADB% %DEVICE% install Chapter1-Android-Shipping-arm64.apk
@if "%ERRORLEVEL%" NEQ "0" goto Error
%ADB% %DEVICE% shell pm list packages com.YourCompany.Chapter1



%ADB% %DEVICE% shell rm -r %STORAGE%/UnrealGame/Chapter1
%ADB% %DEVICE% shell rm -r %STORAGE%/UnrealGame/UECommandLine.txt
%ADB% %DEVICE% shell rm -r %STORAGE%/obb/com.YourCompany.Chapter1
%ADB% %DEVICE% shell rm -r %STORAGE%/Android/obb/com.YourCompany.Chapter1
%ADB% %DEVICE% shell rm -r %STORAGE%/Download/obb/com.YourCompany.Chapter1












@echo.
@echo Grant READ_EXTERNAL_STORAGE and WRITE_EXTERNAL_STORAGE to the apk for reading OBB file or game file in external storage.
%ADB% %DEVICE% shell pm grant com.YourCompany.Chapter1 android.permission.READ_EXTERNAL_STORAGE >nul 2>&1
%ADB% %DEVICE% shell pm grant com.YourCompany.Chapter1 android.permission.WRITE_EXTERNAL_STORAGE >nul 2>&1

@echo.
@echo Installation successful
goto:eof
:Error
@echo.
@echo There was an error installing the game or the obb file. Look above for more info.
@echo.
@echo Things to try:
@echo Check that the device (and only the device) is listed with "%ADB$ devices" from a command prompt.
@echo Make sure all Developer options look normal on the device
@echo Check that the device has an SD card.
@pause
