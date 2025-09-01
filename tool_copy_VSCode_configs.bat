@echo off
setlocal enabledelayedexpansion


:: Verifica se o env está ativado
if defined VIRTUAL_ENV (
    echo [ERRO] Você está no ambiente virtual!
    echo Por favor, execute este script fora do ambiente virtual para ter acesso a pasta %USERPROFILE%.
    echo Execute 'exit' para sair e rode novamente.
    pause
    exit /b 1
)

set "source=%USERPROFILE%\.vscode"
set "destination=data\userprofile\.vscode"

if not exist "%source%" (
    echo A pasta .vscode nao existe em %USERPROFILE%.
    exit /b 1
)

:: xcopy /e /i /h "%source%" "%destination%"
robocopy "%source%" "%destination%" /E

echo Pasta .vscode copiada para %destination%
pause