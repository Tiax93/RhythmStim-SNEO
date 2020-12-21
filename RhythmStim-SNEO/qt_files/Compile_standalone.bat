@echo off

title Make Intan application standalone

cd build*
set curdir=%cd%

call C:\Qt\5.13.1\mingw73_64\bin\qtenv2.bat
call C:\Qt\5.13.1\mingw73_64\bin\windeployqt.exe "%curdir%\release"

timeout /t -1