@echo off
cd /d %~dp0

REM �萔��`
set LOG_DIR=log
set BACKUP_LIST=backup_list.txt

REM ���O�t�@�C�����p�ɓ������擾
REM 0123456789012345
REM 2022/07/24
REM  1:42:45.98
set DATE_STR=%DATE:/=%
set TIME_TMP1=%TIME: =0%
set TIME_TMP2=%TIME_TMP1:~0,8%
set TIME_STR=%TIME_TMP2::=%
set TMP_FILE=backup_%DATE_STR%_%TIME_STR%.tmp
set LOG_FILE=backup_%DATE_STR%_%TIME_STR%.log

REM ���O�t�@�C���t�H���_���Ȃ���΍쐬
if not exist "%LOG_DIR%" (
 md "%LOG_DIR%"
)

REM ���O�t�@�C���̃p�X���쐬
set TMP_PATH=%LOG_DIR%\%TMP_FILE%
set LOG_PATH=%LOG_DIR%\%LOG_FILE%

REM ���O�t�@�C�����쐬
if not exist "%TMP_PATH%" (
 type null > "%TMP_PATH%"
)
if not exist "%LOG_PATH%" (
 type null > "%LOG_PATH%"
)

REM �o�b�N�A�b�v���X�g��1�s���ǂݍ���Ńo�b�N�A�b�v���{
for /f "tokens=1,2,* delims=	" %%a in (%BACKUP_LIST%) do (
 call :backup "%%~a" "%%~b" %%c
)

REM ���O�t�@�C���𐮌`
setlocal EnableDelayedExpansion
for /f "delims=" %%a in (%TMP_PATH%) do (
 set LINE=%%a
 set LINE=!LINE:  �J�n:=        �J�n:!
 set LINE=!LINE:   �R�s�[�� :=    �R�s�[��:!
 set LINE=!LINE:     �R�s�[�� :=    �R�s�[��:!
 set LINE=!LINE:                  ���v     �R�s�[�ς�      �X�L�b�v       �s��v        ���s    Extras=                      ���v  COPY�ς�  �X�L�b�v    �s��v      ���s    Extras!
 set LINE=!LINE:     �t�@�C��:=       �t�@�C��:!
 set LINE=!LINE:      �o�C�g:=         �o�C�g:!
 set LINE=!LINE:       ����:=           ����:!
 set LINE=!LINE:        ���x:=            ���x:!
 set LINE=!LINE:   �I��:=           �I��:!
 echo. !LINE! >> %LOG_PATH%
)
endlocal
del /Q "%TMP_PATH%"

REM ���O�̃��[�e�[�g
REM �ٍ��roglotate.bat�𗘗p
set ROGLOTATE="..\roglotate\roglotate.bat"
if exist %ROGLOTATE% (
 call %ROGLOTATE% "%LOG_DIR%" /rotate 1 /compress
)

pause
exit /b 0

REM =================================================
REM �o�b�N�A�b�v�{��
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
REM echo %SRC% �� %DST% �i%OPT%�j
REM dry run �̏ꍇ�� /L ������
robocopy %SRC% %DST% /E /R:3 /W:5 /DCOPY:DAT /NP /LOG+:"%TMP_PATH%" %OPT%

exit /b 0