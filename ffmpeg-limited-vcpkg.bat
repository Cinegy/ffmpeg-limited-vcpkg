@echo off
setlocal enableextensions
cd /d "%~dp0"

set VERSUFFIX=-limited-1

set VCPKG=.\vcpkg

del /q ffmpeg-*.7z >nul
if exist %VCPKG% rmdir /s /q %VCPKG%

git clone --no-checkout https://github.com/microsoft/vcpkg
if ERRORLEVEL 1 goto FAILED

cd %VCPKG%
git checkout d679a1e0befa9c9e36fcda169c94f6daba2224b7
if ERRORLEVEL 1 goto FAILED
git apply ..\ffmpeg-limited.diff
if ERRORLEVEL 1 goto FAILED

call bootstrap-vcpkg.bat -disableMetrics
if ERRORLEVEL 1 goto FAILED

vcpkg install ffmpeg[core,swresample,swscale,avfilter,avcodec]:x86-windows --recurse --no-binarycaching
if ERRORLEVEL 1 goto FAILED
vcpkg install ffmpeg[core,swresample,swscale,avfilter,avcodec]:x64-windows --recurse --no-binarycaching
if ERRORLEVEL 1 goto FAILED

cd /d "%~dp0"

for /f "tokens=2" %%I in ('%VCPKG%\vcpkg list ffmpeg:x64') do set VER=%%I%VERSUFFIX%

for /d %%I in (%VCPKG%\downloads\tools\7zip*) do set LOCALPATH=;%%I\Files\7-Zip
set PATH=%PATH%;%ProgramFiles%\7-Zip;%ProgramFiles(x86)%\7-Zip%LOCALPATH%

where 7z 2>&1 1>nul

if ERRORLEVEL 1 (
  echo "7-Zip not installed - please install and retry"
  goto FAILED
)

set EXCLUDE=-x!share -x!tools -xr!ffnvcodec* -xr!pkgconfig

7z a ffmpeg-%VER%-x86.7z %VCPKG%\installed\x86-windows\* %EXCLUDE%
if ERRORLEVEL 1 goto FAILED
7z a ffmpeg-%VER%-x64.7z %VCPKG%\installed\x64-windows\* %EXCLUDE%
if ERRORLEVEL 1 goto FAILED

exit /b 0

:FAILED
pause
cd /d "%~dp0"
exit /b 1
