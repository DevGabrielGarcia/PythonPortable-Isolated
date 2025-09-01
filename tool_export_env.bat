@echo off
setlocal

:: Caminhos
set "ROOT_DIR=%~dp0"
set "VENV_DIR=%ROOT_DIR%.venv"
set "PIP_EXE=%VENV_DIR%\Scripts\pip.exe"
set "REQ_FILE=%ROOT_DIR%requirements.txt"

:: Verifica se o pip existe
if not exist "%PIP_EXE%" (
    echo [ERRO] pip nao encontrado. Voce precisa rodar primeiro o initial_configure_python-embed.bat
    pause
    exit /b 1
)

:: Cria requirements.txt
pip freeze > requirements.txt

echo.
echo ✅ requirements.txt criado com sucesso!
pause
exit /b