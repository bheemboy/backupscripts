call rsnapshot.bat weekly "C:\Users\surehman\Google Drive" "C:\Backup" rotate
call rsnapshot.bat weekly "C:\Users\surehman\OneDrive - Agilent Technologies" "C:\Backup"
call rsnapshot.bat weekly "C:\Archive" "C:\Backup"
call rsnapshot.bat weekly "C:\Projects" "C:\Backup"

if not exist "Q:\Backup" goto :done
call rsnapshot.bat weekly "C:\Users\surehman\Google Drive" "Q:\Backup" rotate
call rsnapshot.bat weekly "C:\Users\surehman\OneDrive - Agilent Technologies" "Q:\Backup"
call rsnapshot.bat weekly "C:\Archive" "Q:\Backup"
call rsnapshot.bat weekly "C:\Projects" "Q:\Backup"

:done
