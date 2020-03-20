@echo off
rem Audiokinetic All Android Sound Engine build Script
SETLOCAL

set tmpNDKROOT="%NDKROOT%"
set inDir=%~dp0
set inDir=%inDir:\=/%
set inDir=%inDir: =\ %

if /I "%1" == "help" goto SHOW_USAGE
if /I "%1" == "-h" goto SHOW_USAGE
if /I "%1" == "-help" goto SHOW_USAGE
if /I "%1" == "--help" goto SHOW_USAGE
if /I "%1" == "/?" goto SHOW_USAGE
if /I "%1" == "/help" goto SHOW_USAGE

IF "%NDKROOT%"=="" ECHO NDKROOT is NOT defined. Make sure you have installed android NDK and that the NDKROOT environment variable is set to the NDK directory (ex: C:/AndroidNDK/r17c)

if /I "%1" == "armeabi-v7a" (
    Set ANDROID_ARCH=armeabi-v7a
) else (
    if /I "%1" == "x86" (
        Set ANDROID_ARCH=x86
    ) else (
        if /I "%1" == "arm64-v8a" (
            Set ANDROID_ARCH=arm64-v8a
        ) else (
            if /I "%1" == "x86_64" (
                Set ANDROID_ARCH=x86_64
            ) else (
                Echo . error Invalid arch: %1. Supported architectures are : armeabi-v7a, x86, arm64-v8a, x86_64
                goto END
            )
        )
    )
)

if /I "%2" == "debug" (
 Set CONFIG=debug
) else (
    if /I "%2" == "profile" (
     Set CONFIG=profile
    ) else (
        if /I "%2" == "release" (
         Set CONFIG=release
        ) else (
            Echo . error Invalid config: %2. Supported configurations are: debug, profile, release
            goto END
        )
    )
)


Set NDK_SOUNDENGINE_COMMAND="%NDKROOT%/ndk-build" all -j 8 NDK_PROJECT_PATH=.\ PM5_CONFIG=%CONFIG%_android_%ANDROID_ARCH% APP_BUILD_SCRIPT=AllAndroidSoundEngine.mk NDK_APPLICATION_MK=AllAndroidSoundEngine_application.mk NDK_LIBS_OUT=../../Android_%ANDROID_ARCH%/%CONFIG%/libs NDK_OUT=../../Android_%ANDROID_ARCH%/%CONFIG%/lib NDK_APP_OUT=../../Android_%ANDROID_ARCH%/%CONFIG% TARGET_OUT=../../Android_%ANDROID_ARCH%/%CONFIG%/lib

Echo Building sound engine...
Echo %NDK_SOUNDENGINE_COMMAND%
CALL %NDK_SOUNDENGINE_COMMAND%

goto END
:SHOW_USAGE
echo.
echo Audiokinetic All Android Sound Engine build Script
echo.
echo This script is using ndk-build.
echo Official Supported version is ndk-r17c.
echo.
echo    Usage: Build.cmd [armeabi-v7a^|x86^|arm64-v8a^|x86_64] [Debug^|Profile^|Release]
echo.
echo    Example:
echo       BuildAllAndroid.cmd armeabi-v7a debug
echo.
goto END
:END


ENDLOCAL



