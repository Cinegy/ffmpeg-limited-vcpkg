@echo off
setlocal enableextensions
cd /d "%~dp0"

if exist .\vcpkg rmdir /s /q .\vcpkg

git clone --no-checkout https://github.com/microsoft/vcpkg
if ERRORLEVEL 1 goto error

cd .\vcpkg
git checkout d679a1e0befa9c9e36fcda169c94f6daba2224b7
if ERRORLEVEL 1 goto Error
git apply ..\ffmpeg-limited.diff
if ERRORLEVEL 1 goto Error

call bootstrap-vcpkg.bat -disableMetrics
if ERRORLEVEL 1 goto Error

vcpkg install ffmpeg[core,swresample,swscale,avfilter,avcodec]:x86-windows --recurse
if ERRORLEVEL 1 goto Error
vcpkg install ffmpeg[core,swresample,swscale,avfilter,avcodec]:x64-windows --recurse
if ERRORLEVEL 1 goto Error

cd /d "%~dp0"

@REM set VER=4.4#14-limited-1
@REM set EXCLUDE=-x!share -x!tools -xr!ffnvcodec* -xr!pkgconfig

@REM %SEVENZIP% a ffmpeg-%VER%-x86.7z .\vcpkg\installed\x86-windows\* %EXCLUDE%
@REM if ERRORLEVEL 1 goto Error
@REM %SEVENZIP% a ffmpeg-%VER%-x64.7z .\vcpkg\installed\x64-windows\* %EXCLUDE%
@REM if ERRORLEVEL 1 goto Error

exit /b 0

:Error
pause
cd /d "%~dp0"
exit /b 1