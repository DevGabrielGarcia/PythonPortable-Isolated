@echo off
setlocal

echo Limpando caches e arquivos temporarios do pip e do sistema...

:: Caminhos
set "LOCALAPPDATA=%LocalAppData%"
set "PIP_CACHE=%LOCALAPPDATA%\pip"
set "PYPA_CACHE=%LOCALAPPDATA%\pypa"
set "TEMP_CACHE=%LOCALAPPDATA%\Temp"

:: Apagar pip
if exist "%PIP_CACHE%" (
    echo Apagando: %PIP_CACHE%
    rmdir /s /q "%PIP_CACHE%"
)

:: Apagar pypa
if exist "%PYPA_CACHE%" (
    echo Apagando: %PYPA_CACHE%
    rmdir /s /q "%PYPA_CACHE%"
)

:: Apagar todo o Temp
if exist "%TEMP_CACHE%" (
    echo Limpando arquivos de: %TEMP_CACHE%
    for /d %%D in ("%TEMP_CACHE%\*") do (
        echo Apagando pasta: %%D
        rmdir /s /q "%%D" 2>nul
    )
    for %%F in ("%TEMP_CACHE%\*") do (
        echo Apagando arquivo: %%F
        del /f /q "%%F" 2>nul
    )
)

echo.
echo ✅ Limpeza concluida.
pause
exit /b
