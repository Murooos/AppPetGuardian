@echo off
echo ========================================
echo Instalando dependencias do AppPetGuardian
echo ========================================
echo.

echo [1/2] Instalando dependencias principais...
pip install fastapi uvicorn[standard] PyJWT python-dotenv

echo.
echo [2/2] Tentando instalar oracledb...
echo Se falhar, instale o Microsoft C++ Build Tools
echo ou use: pip install --upgrade oracledb
pip install oracledb

echo.
echo ========================================
echo Instalacao concluida!
echo ========================================
pause

