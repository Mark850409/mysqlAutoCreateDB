@echo off
chcp 65001
echo ===========================
echo 歡迎使用資料庫匯入小程式!!!
echo 請依照以下提示訊息輸入!!!
echo ===========================

echo.
echo.

echo =========注意事項==========
echo 1.放SQL的檔案路徑不能有中文!!!
echo 2.提示訊息的輸入不得為空!!!
echo 3.請事先下載好SQL檔案
echo ===========================

echo.

cd /d C:/Program Files/MySQL/MySQL Server 8.0/bin

:UserNamePrompt
set /P name=請輸入資料庫帳號：
if not defined name goto UserNamePrompt
if %name% neq "" goto pwPrompt

:pwPrompt
set /p pw=請輸入資料庫密碼：
if not defined pw goto pwPrompt
if %pw% neq "" goto pathPrompt


:pathPrompt
set /p mypath=請輸入資料庫檔案路徑：
if not defined mypath goto pathPrompt
if %mypath% neq "" goto checkpath

:checkpath
if exist %mypath% (
  goto importsql 
) else (
  echo "路徑輸入錯誤，請重新輸入!!!"
  goto end
)


:importsql
REM echo %mypath%/Createstocktable.sql
mysql -u %name% -p%pw% -e "source %mypath%/Createstocktable.sql;" -e "use stock;" -e "source %mypath%/ExportstockTable.sql;"
goto openfiles


:openfiles
start  "" "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads"
goto end

:end
pause