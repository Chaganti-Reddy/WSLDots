@echo off
echo Cleaning up temporary files...
echo.

:: Deleting all files in %TEMP%
del /s /f /q "%TEMP%\*.*"

:: Deleting all folders in %TEMP%
for /d %%x in ("%TEMP%\*") do rd /s /q "%%x"

echo.
echo Temporary files cleaned successfully!
pause
