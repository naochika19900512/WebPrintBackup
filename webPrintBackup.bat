@echo off
setlocal

rem バックアップ元フォルダパスを指定する
set backup_source=C:\Program Files\PaperCut MF\providers\web-print\win\logs

rem バックアップ先フォルダパスを指定する
set backup_destination=C:\Program Files\PaperCut MF\providers\web-print\win\bkup

rem Web Print.lnkの場所を指定する
set webPrintLink=C:\ProgramData\Microsoft\Windows\Start Menu\Programs\PaperCut MF\Web Print.lnk

rem 10世代以内のバックアップフォルダを残す
set max_generations=10

rem バックアップフォルダがない場合、作成
if not exist "%backup_destination%" mkdir "%backup_destination%"

rem バックアップフォルダ名の作成(秒数)
set /a num_backups=0
for /d %%i in ("%backup_destination%\backup_*") do set /a num_backups+=1

rem 新しいバックアップフォルダの作成
set backup_folder=backup_%date:~0,4%%date:~5,2%%date:~8,2%_%time:~0,2%%time:~3,2%%time:~6,2%
mkdir "%backup_destination%\%backup_folder%"

rem バックアップ元フォルダをバックアップ先フォルダにコピーする
xcopy "%backup_source%" "%backup_destination%\%backup_folder%" /s /e /h /i

rem 11世代以降のバックアップフォルダを削除する
for /f "skip=%max_generations% delims=" %%f in ('dir /b /ad /o-d "%backup_destination%" ^| findstr /r /c:"^backup_"') do (
  rmdir /s /q "%backup_destination%\%%f"
)

REM pc-web-print.exeを停止する
taskkill /IM pc-web-print.exe /F

REM ログファイルを削除する
del /F /Q "%backup_source%\*"

REM pc-web-print.exeを開始する
start "" "%webPrintLink%"
