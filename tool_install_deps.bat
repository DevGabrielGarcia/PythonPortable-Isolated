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

:: Verifica se requirements.txt existe
if not exist "%REQ_FILE%" (
    echo [ERRO] Arquivo requirements.txt nao encontrado em: %REQ_FILE%
    pause
    exit /b 1
)

echo Instalando dependencias do requirements.txt...
"%PIP_EXE%" install -r "%REQ_FILE%"
if errorlevel 1 (
    echo [ERRO] Falha ao instalar dependencias.
    pause
    exit /b 1
)

echo.
echo ✅ Dependencias instaladas com sucesso.
pause
exit /b