@echo off
chcp 65001 >nul
echo 🚀 Script de teste para Firebase Cloud Functions
echo.

REM Configurações - SUBSTITUA PELOS SEUS VALORES REAIS
set PROJECT_ID=seu-projeto-firebase
set REGION=us-central1
set USER_ID=USER_ID_TESTE
set MICROTASK_ID=MICROTASK_ID_TESTE
set TASK_ID=TASK_ID_TESTE
set EVENT_ID=EVENT_ID_TESTE

echo ⚠️  IMPORTANTE: Edite este arquivo e substitua os valores de teste pelos IDs reais!
echo.
echo Configurações atuais:
echo - PROJECT_ID: %PROJECT_ID%
echo - REGION: %REGION%
echo - USER_ID: %USER_ID%
echo - MICROTASK_ID: %MICROTASK_ID%
echo - TASK_ID: %TASK_ID%
echo - EVENT_ID: %EVENT_ID%
echo.

REM Verifica se curl está disponível
curl --version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Erro: curl não está instalado ou não está no PATH
    echo Instale o curl ou use o PowerShell script como alternativa
    pause
    exit /b 1
)

REM URLs das Cloud Functions
set BASE_URL=https://%REGION%-%PROJECT_ID%.cloudfunctions.net

echo 📝 Testando updateMicrotaskStatus...
echo URL: %BASE_URL%/updateMicrotaskStatus
echo JSON: {"userId":"%USER_ID%","microtaskId":"%MICROTASK_ID%","status":"in_progress"}
echo.
curl -X POST "%BASE_URL%/updateMicrotaskStatus" -H "Content-Type: application/json" -d "{\"userId\":\"%USER_ID%\",\"microtaskId\":\"%MICROTASK_ID%\",\"status\":\"in_progress\"}"
echo.
echo ----------------------------------------
echo.

echo 📋 Testando updateTaskStatus...
echo URL: %BASE_URL%/updateTaskStatus
echo JSON: {"taskId":"%TASK_ID%","status":"in_progress"}
echo.
curl -X POST "%BASE_URL%/updateTaskStatus" -H "Content-Type: application/json" -d "{\"taskId\":\"%TASK_ID%\",\"status\":\"in_progress\"}"
echo.
echo ----------------------------------------
echo.

echo 📊 Testando getTaskStatistics...
echo URL: %BASE_URL%/getTaskStatistics
echo JSON: {"eventId":"%EVENT_ID%"}
echo.
curl -X POST "%BASE_URL%/getTaskStatistics" -H "Content-Type: application/json" -d "{\"eventId\":\"%EVENT_ID%\"}"
echo.
echo ----------------------------------------
echo.

echo ✅ Testes concluídos!
echo.
echo 💡 Dicas:
echo - Verifique os logs no Firebase Console para mais detalhes
echo - Se houver erros, verifique se os IDs estão corretos
echo - Para testes autenticados, adicione o header Authorization
echo - Se o curl não funcionar, use o script PowerShell como alternativa
echo.
echo 🔗 Links úteis:
echo - Firebase Console: https://console.firebase.google.com/project/%PROJECT_ID%
echo - Functions Logs: https://console.firebase.google.com/project/%PROJECT_ID%/functions/logs
echo.
pause