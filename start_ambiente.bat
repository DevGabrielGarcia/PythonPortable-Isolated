@echo off
setlocal enabledelayedexpansion

::Variaveis de ambiente
set "PROJECT_DATA=%~dp0data"
set "APPDATA=%PROJECT_DATA%\AppData\Roaming"
set "LOCALAPPDATA=%PROJECT_DATA%\AppData\Local"
set "TEMP=%PROJECT_DATA%\Temp"
set "TMP=%PROJECT_DATA%\Temp"

:: Isolamento avançado
set "USERPROFILE=%PROJECT_DATA%\UserProfile"
set "HOMEPATH=%USERPROFILE%"
set "HOME=%USERPROFILE%"
set "USERNAME=container_user"
:: CSIDLs simulados
set "CSIDL_PROFILE=%USERPROFILE%"
set "CSIDL_APPDATA=%APPDATA%"
set "CSIDL_LOCAL_APPDATA=%LOCALAPPDATA%"
set "CSIDL_PERSONAL=%PROJECT_DATA%\Documents"
set "CSIDL_MYDOCUMENTS=%PROJECT_DATA%\Documents"
set "CSIDL_DESKTOPDIRECTORY=%PROJECT_DATA%\Desktop"
set "CSIDL_PROGRAMS=%PROJECT_DATA%\Programs"
set "CSIDL_RECENT=%PROJECT_DATA%\Recent"
set "CSIDL_SENDTO=%PROJECT_DATA%\SendTo"
set "CSIDL_STARTMENU=%PROJECT_DATA%\StartMenu"
set "CSIDL_STARTUP=%PROJECT_DATA%\Startup"
set "CSIDL_TEMPLATES=%PROJECT_DATA%\Templates"
:: Python environment isolation
set "PYTHONUSERBASE=%PROJECT_DATA%\PythonUserBase"
set "PYTHONPYCACHEPREFIX=%PROJECT_DATA%\__pycache__"
set "PYTHONNOUSERSITE=1"
:: Pip cache/config
set "PIP_CACHE_DIR=%PROJECT_DATA%\pip_cache"
:: set "PIP_CONFIG_FILE=%PROJECT_DATA%\pip\pip.ini"  :: (descomente se quiser usar pip config)

::Cria pastas das variaveis de ambiente
for %%D in ("%PROJECT_DATA%"
            "%APPDATA%"
            "%LOCALAPPDATA%"
            "%TEMP%"
            "%USERPROFILE%"
            "%PIP_CACHE_DIR%"
            "%PYTHONPYCACHEPREFIX%") do (
    if not exist "%%~D" mkdir "%%~D"
)



:: Caminhos base
set "ROOT_DIR=%~dp0"
set "PYTHON_DIR=%ROOT_DIR%python-embed\"
set "PYTHON_EXE=%PYTHON_DIR%\python.exe"
set "VENV_DIR=%ROOT_DIR%.venv"

:: Verifica se o python.exe existe
if not exist "%PYTHON_EXE%" (
    echo [ERRO] python.exe não encontrado em: %PYTHON_EXE%
    pause
    exit /b 1
)

:: Verifica se o virtualenv está instalado
echo Verificando se virtualenv está disponível...
"%PYTHON_EXE%" -m virtualenv --version >nul 2>&1
if errorlevel 1 (
    echo [ERRO] virtualenv não está instalado.
    echo Instale com:
    echo     %PYTHON_EXE% --no-cache-dir -m pip install virtualenv
    pause
    exit /b 1
)

:: Cria o ambiente virtual se não existir
if not exist "%VENV_DIR%\Scripts\activate.bat" (
    echo Criando ambiente virtual com virtualenv...
    "%PYTHON_EXE%" --no-cache-dir -m virtualenv "%VENV_DIR%"
)

:: Ativa o ambiente
echo Ativando ambiente virtual...
call "%VENV_DIR%\Scripts\activate.bat"

:: Entrar no shell com o ambiente ativo
echo Ambiente virtual ativado com sucesso.
cmd /k
