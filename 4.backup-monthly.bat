call rsnapshot.bat monthly "C:\Users\surehman\Google Drive" "C:\Backup" rotate
call rsnapshot.bat monthly "C:\Users\surehman\OneDrive - Agilent Technologies" "C:\Backup"
call rsnapshot.bat monthly "C:\Archive" "C:\Backup"
call rsnapshot.bat monthly "C:\Projects" "C:\Backup"

if not exist "Q:\Backup" goto :done
call rsnapshot.bat monthly "C:\Users\surehman\Google Drive" "Q:\Backup" rotate
call rsnapshot.bat monthly "C:\Users\surehman\OneDrive - Agilent Technologies" "Q:\Backup"
call rsnapshot.bat monthly "C:\Archive" "Q:\Backup"
call rsnapshot.bat monthly "C:\Projects" "Q:\Backup"

:done
