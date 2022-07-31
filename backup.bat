@echo off
cd /d %~dp0

REM 定数定義
set LOG_DIR=log
set BACKUP_LIST=backup_list.txt

REM ログファイル名用に日時を取得
REM 0123456789012345
REM 2022/07/24
REM  1:42:45.98
set DATE_STR=%DATE:/=%
set TIME_TMP1=%TIME: =0%
set TIME_TMP2=%TIME_TMP1:~0,8%
set TIME_STR=%TIME_TMP2::=%
set TMP_FILE=backup_%DATE_STR%_%TIME_STR%.tmp
set LOG_FILE=backup_%DATE_STR%_%TIME_STR%.log

REM ログファイルフォルダがなければ作成
if not exist "%LOG_DIR%" (
 md "%LOG_DIR%"
)

REM ログファイルのパスを作成
set TMP_PATH=%LOG_DIR%\%TMP_FILE%
set LOG_PATH=%LOG_DIR%\%LOG_FILE%

REM ログファイルを作成
if not exist "%TMP_PATH%" (
 type null > "%TMP_PATH%"
)
if not exist "%LOG_PATH%" (
 type null > "%LOG_PATH%"
)

REM バックアップリストを1行ずつ読み込んでバックアップ実施
for /f "tokens=1,2,* delims=	" %%a in (%BACKUP_LIST%) do (
 call :backup "%%~a" "%%~b" %%c
)

REM ログファイルを整形
setlocal EnableDelayedExpansion
for /f "delims=" %%a in (%TMP_PATH%) do (
 set LINE=%%a
 set LINE=!LINE:  開始:=        開始:!
 set LINE=!LINE:   コピー元 :=    コピー元:!
 set LINE=!LINE:     コピー先 :=    コピー先:!
 set LINE=!LINE:                  合計     コピー済み      スキップ       不一致        失敗    Extras=                      合計  COPY済み  スキップ    不一致      失敗    Extras!
 set LINE=!LINE:     ファイル:=       ファイル:!
 set LINE=!LINE:      バイト:=         バイト:!
 set LINE=!LINE:       時刻:=           時刻:!
 set LINE=!LINE:        速度:=            速度:!
 set LINE=!LINE:   終了:=           終了:!
 echo. !LINE! >> %LOG_PATH%
)
endlocal
del /Q "%TMP_PATH%"

REM ログのローテート
REM 拙作のroglotate.batを利用
set ROGLOTATE="..\roglotate\roglotate.bat"
if exist %ROGLOTATE% (
 call %ROGLOTATE% "%LOG_DIR%" /rotate 1 /compress
)

pause
exit /b 0

REM =================================================
REM バックアップ本体
REM =================================================
:backup
set SRC=%1
@shift
set DST=%1
@shift
set OPT=
:loop
if "%~1"=="" goto :end
set OPT=%OPT% %1
@shift
goto :loop
:end
REM echo %SRC% → %DST% （%OPT%）
REM dry run の場合は /L をつける
robocopy %SRC% %DST% /E /R:3 /W:5 /DCOPY:DAT /NP /LOG+:"%TMP_PATH%" %OPT%

exit /b 0