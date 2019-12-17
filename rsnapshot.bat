@echo off

if [%1]==[] GOTO :usage
if [%2]==[] GOTO :usage
if [%3]==[] GOTO :usage

IF NOT EXIST %2 GOTO :invalidsourcedir

IF NOT EXIST %3 GOTO :invalidbackdir

if [%1]==[hourly] GOTO :start
if [%1]==[daily] GOTO :start
if [%1]==[weekly] GOTO :start
if [%1]==[monthly] GOTO :start

:usage
@echo Usage: 
@echo "rsnapshot [hourly|daily|weekly|monthly] [sourcedir] [backupdir] [rotate? 0 for no]"
goto:eof

:invalidsourcedir
@echo Source directory %2 does not exist
goto:eof

:invalidbackdir
@echo Backup directory %3 does not exist
goto:eof

:start
set typ=%~1
set src=%~2
set bak=%~3

set back0=%bak%\%typ%.0

rem if no rotation is requied robocopy to the .0 folder.
if NOT [%4]==[rotate] GOTO :robocopy

rem
rem ROTATE BACKUP FOLDERS
rem 

rem rename the folders up to create space for a new .0 folder.
@echo on
ren "%bak%\%typ%.3" "%typ%.4"
ren "%bak%\%typ%.2" "%typ%.3"
ren "%bak%\%typ%.1" "%typ%.2"
ren "%bak%\%typ%.0" "%typ%.1"

rem
rem FIND MOST RECENT BACKUP FOLDER OF SAME OR A MORE FREQUENT BACKUP TYPE
rem 

rem If a newly renamed .1 folder of the same type does not exist go to :special
set back1=%bak%\%typ%.1
if not exist "%back1%" goto :special
goto :createlinks

rem find the most recent .0 folder for the more frequent backup type
:special
if [%1]==[monthly] GOTO :monthly
if [%1]==[weekly] GOTO :weekly
if [%1]==[daily] GOTO :daily
if [%1]==[hourly] GOTO :robocopy

:monthly
set back1=%bak%\weekly.0
if not exist "%back1%" goto :weekly
goto :createlinks

:weekly
set back1=%bak%\daily.0
if not exist "%back1%" goto :daily
goto :createlinks

:daily
set back1=%bak%\hourly.0
if not exist "%back1%" goto :robocopy
goto :createlinks

:createlinks
REM
REM LINK FILES FROM MOST RECENT
REM
rem create links from most recent folder of same type or a more frequent type.
xcopy "%back1%" "%back0%"\ /e /t /h /c /r /y
@echo off
for /f "tokens=* delims=" %%i in ('dir /b/s/a-d "%back1%\*"') do call :MakeLink "%%i" "%back1%" "%back0%"


:robocopy
REM
REM OVERWRITE .0 FOLDER USING ROBOCOPY AND REMOVE .4 FOLDER
REM 
@echo on
robocopy "%src%" "%back0%%~pn2" /MIR /R:1 /W:5 /FFT
if exist "%bak%\%typ%.4" rmdir /s /q "%bak%\%typ%.4"
@echo off
:end
GOTO:EOF


:MakeLink
rem Make link subroutine
set dest=%1
call set dest=%%dest:%~2=%~3%%
call mklink /h %dest% "%~1"
GOTO:EOF

