@echo off
chcp 65001
echo ===========================
echo 歡迎使用資料庫匯入小程式!!!
echo 請依照以下提示訊息輸入!!!
echo ===========================

echo.
echo.

echo =========注意事項==========
echo 1.提示訊息的輸入不得為空!!!
echo 2.請事先下載好SQL檔案
echo 3.MYSQL SERVER是否啟動!!!
echo ===========================

echo.

:CheckMysql
echo =========以下為您的MYSQL狀態==========
netstat -ano | findstr 3306
echo ======================================
if %ERRORLEVEL% equ 0 goto UserNamePrompt
echo "MYSQL未啟動，請檢查詳細原因!!!"
goto end


:UserNamePrompt
echo.
set /P name=請輸入資料庫帳號：
if not defined name goto UserNamePrompt
if %name% neq "" goto pwPrompt

:pwPrompt
set /p pw=請輸入資料庫密碼：
if not defined pw goto pwPrompt
if %pw% neq "" goto importsql


REM :pathPrompt
REM set /p mypath=請輸入資料庫檔案路徑：
REM if not defined mypath goto pathPrompt
REM if %mypath% neq "" goto checkpath

REM :checkpath
REM if exist %mypath% (
  REM goto importsql 
REM ) else (
  REM echo "路徑輸入錯誤，請重新輸入!!!"
  REM goto end
REM )


:importsql
"C:/Program Files/MySQL/MySQL Server 8.0/bin/mysql.exe" mysql -u %name% -p%pw% -e "source Createstocktable.sql;" -e "use stock;" -e "source ExportstockTable.sql;"
if "%ERRORLEVEL%" EQU "0" (
  goto openfiles
) else (
   echo "MYSQL帳密輸入錯誤，請重新輸入!!!"
   goto UserNamePrompt
)

:openfiles
start  "" "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads"
goto end

:end
pause