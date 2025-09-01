@echo off
setlocal enabledelayedexpansion

:: Python environment isolation
set "PROJECT_DATA=%~dp0data"
set "PYTHONUSERBASE=%PROJECT_DATA%\PythonUserBase"
set "PYTHONPYCACHEPREFIX=%PROJECT_DATA%\__pycache__"
set "PYTHONNOUSERSITE=1"
:: Pip cache/config
set "PIP_CACHE_DIR=%PROJECT_DATA%\pip_cache"


:: Caminhos
set "ROOT_DIR=%~dp0"
set "PYTHON_DIR=%ROOT_DIR%python-embed"
set "PYTHON_EXE=%PYTHON_DIR%\python.exe"
set "VENV_DIR=%ROOT_DIR%.venv"

:: Verificar se python.exe existe
if not exist "%PYTHON_EXE%" (
    echo [ERRO] python.exe não encontrado em: %PYTHON_EXE%
    pause
    exit /b 1
)

:: 1. Detectar versão do Python
for /f "tokens=2 delims= " %%v in ('"%PYTHON_EXE%" --version 2^>^&1') do (
    set "PYTHON_VERSION=%%v"
)

:: 2. Criar arquivo infoVersion_python<versao>.txt
set "SAFE_VERSION=%PYTHON_VERSION:.=_%"
set "SAFE_VERSION=%SAFE_VERSION: =_%"
set "VERSION_FILE=infoVersion_python%SAFE_VERSION%.txt"
"%PYTHON_EXE%" --version > "%VERSION_FILE%"
echo Versao detectada: %PYTHON_VERSION%
echo Criado arquivo: %VERSION_FILE%

:: 3. Detectar e corrigir o ._pth file (habilitar import site)
setlocal enabledelayedexpansion
set "PTH_FILE="
for %%f in ("%PYTHON_DIR%\python*._pth") do (
    set "PTH_FILE=%%~f"
)

if defined PTH_FILE (
    echo Arquivo .pth encontrado: !PTH_FILE!

    set "FOUND=0"
    for /f "usebackq delims=" %%L in ("!PTH_FILE!") do (
        set "LINE=%%L"
        set "LINE=!LINE: =!"
        if "!LINE!"=="importsite" (
            set "FOUND=1"
        )
    )

    if "!FOUND!"=="0" (
        echo Corrigindo arquivo .pth para habilitar 'import site'
        echo import site>> "!PTH_FILE!"
    ) else (
        echo 'import site' ja habilitado em: !PTH_FILE!
    )
) else (
    echo [AVISO] Nenhum arquivo .pth encontrado para editar.
)
endlocal


set "GET_PIP_URL=https://bootstrap.pypa.io/get-pip.py"
set "GET_PIP_FILE=%PYTHON_DIR%\get-pip.py"

:: 4. Verifica se pip existe
"%PYTHON_EXE%" -m pip --version >nul 2>&1
if errorlevel 1 (
    echo Instalando pip com get-pip.py...

    powershell -Command "Invoke-WebRequest -Uri '%GET_PIP_URL%' -OutFile '%GET_PIP_FILE%'"
    if exist "%GET_PIP_FILE%" (
        "%PYTHON_EXE%" "%GET_PIP_FILE%"
        del "%GET_PIP_FILE%"
    ) else (
        echo [ERRO] Falha ao baixar get-pip.py
        echo.
        echo Baixe manualmente: %GET_PIP_URL%
        echo Salve em: %GET_PIP_FILE%
        echo.
        echo Pressione ENTER para continuar apos baixar...
        pause
        if exist "%GET_PIP_FILE%" (
            "%PYTHON_EXE%" "%GET_PIP_FILE%"
            del "%GET_PIP_FILE%"
        ) else (
            echo [ERRO] Ainda nao foi possivel instalar o pip.
            pause
            exit /b 1
        )
    )
) else (
    echo pip ja esta instalado.
)

:: 5. Verificar e instalar virtualenv
"%PYTHON_EXE%" -m virtualenv --version >nul 2>&1
if errorlevel 1 (
    echo Instalando virtualenv...
    "%PYTHON_EXE%" -m pip install virtualenv
) else (
    echo virtualenv ja esta instalado.
)

:: 6. Criar o ambiente .venv se ainda não existir
if not exist "%VENV_DIR%\Scripts\activate.bat" (
    echo Criando ambiente virtual em: %VENV_DIR%
    "%PYTHON_EXE%" -m virtualenv "%VENV_DIR%"
    if errorlevel 1 (
        echo [ERRO] Falha ao criar o ambiente virtual.
        pause
        exit /b 1
    )
) else (
    echo Ambiente .venv ja existe.
)

echo.
echo ✅ Configuracao inicial concluida com sucesso.
pause
exit /b
