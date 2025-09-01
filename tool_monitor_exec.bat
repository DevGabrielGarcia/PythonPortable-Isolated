@echo off
setlocal enabledelayedexpansion

:: Caminhos
set "ROOT_DIR=%~dp0"
set "TOOL_DIR=%ROOT_DIR%tools\procmon"
set "PROCMON_EXE=%TOOL_DIR%\Procmon.exe"
set "FILTER_FILE=%TOOL_DIR%\monitor_filter.pmc"

:: Caminho para o script que será monitorado
set "SCRIPT_TO_RUN=start_ambiente.bat"

:: Verificação
if not exist "%PROCMON_EXE%" (
    echo [ERRO] Procmon.exe não encontrado em: %PROCMON_EXE%
    echo Baixe em:
    echo https://learn.microsoft.com/en-us/sysinternals/downloads/procmon
    pause
    exit /b 1
)

echo Iniciando monitoramento com ProcMon...

:: Inicia ProcMon com filtros, log em segundo plano
start "" "%PROCMON_EXE%" /Quiet /LoadConfig "%FILTER_FILE%"

:: Aguardar um pouco para garantir que ProcMon iniciou
timeout /t 2 >nul

:: Executar o script alvo
echo Executando: %SCRIPT_TO_RUN%
call "%ROOT_DIR%%SCRIPT_TO_RUN%"


echo.
echo ✅ Script finalizado. O Process Monitor continua aberto para análise.
echo ➜ Lembre-se de aplicar filtros visuais e salvar manualmente em CSV, se quiser.
pause
exit /b