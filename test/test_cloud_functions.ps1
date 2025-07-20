# Script PowerShell para testar Firebase Cloud Functions
# Execute com: powershell -ExecutionPolicy Bypass -File test_cloud_functions.ps1

Write-Host "🚀 Script de teste para Firebase Cloud Functions" -ForegroundColor Green
Write-Host ""

# Configurações - SUBSTITUA PELOS SEUS VALORES REAIS
$PROJECT_ID = "seu-projeto-firebase"
$REGION = "us-central1"
$USER_ID = "USER_ID_TESTE"
$MICROTASK_ID = "MICROTASK_ID_TESTE"
$TASK_ID = "TASK_ID_TESTE"
$EVENT_ID = "EVENT_ID_TESTE"

Write-Host "⚠️  IMPORTANTE: Edite este arquivo e substitua os valores de teste pelos IDs reais!" -ForegroundColor Yellow
Write-Host ""
Write-Host "Configurações atuais:"
Write-Host "- PROJECT_ID: $PROJECT_ID"
Write-Host "- REGION: $REGION"
Write-Host "- USER_ID: $USER_ID"
Write-Host "- MICROTASK_ID: $MICROTASK_ID"
Write-Host "- TASK_ID: $TASK_ID"
Write-Host "- EVENT_ID: $EVENT_ID"
Write-Host ""

# URL base das Cloud Functions
$BASE_URL = "https://$REGION-$PROJECT_ID.cloudfunctions.net"

# Função para fazer requisições HTTP
function Invoke-CloudFunction {
    param(
        [string]$FunctionName,
        [hashtable]$Body,
        [string]$Description
    )
    
    Write-Host "📝 Testando $Description..." -ForegroundColor Cyan
    
    try {
        $url = "$BASE_URL/$FunctionName"
        $jsonBody = $Body | ConvertTo-Json -Depth 3
        
        Write-Host "URL: $url" -ForegroundColor Gray
        Write-Host "Body: $jsonBody" -ForegroundColor Gray
        
        $response = Invoke-RestMethod -Uri $url -Method POST -Body $jsonBody -ContentType "application/json" -TimeoutSec 30
        
        Write-Host "✅ Sucesso!" -ForegroundColor Green
        Write-Host "Resposta: $($response | ConvertTo-Json -Depth 3)" -ForegroundColor Green
        
        return $true
    }
    catch {
        Write-Host "❌ Erro: $($_.Exception.Message)" -ForegroundColor Red
        
        if ($_.Exception.Response) {
            $statusCode = $_.Exception.Response.StatusCode
            Write-Host "Status Code: $statusCode" -ForegroundColor Red
            
            try {
                $errorStream = $_.Exception.Response.GetResponseStream()
                $reader = New-Object System.IO.StreamReader($errorStream)
                $errorBody = $reader.ReadToEnd()
                Write-Host "Error Body: $errorBody" -ForegroundColor Red
            }
            catch {
                Write-Host "Não foi possível ler o corpo do erro" -ForegroundColor Red
            }
        }
        
        return $false
    }
    
    Write-Host ""
}

# Teste 1: updateMicrotaskStatus
$body1 = @{
    userId = $USER_ID
    microtaskId = $MICROTASK_ID
    status = "in_progress"
}
$result1 = Invoke-CloudFunction -FunctionName "updateMicrotaskStatus" -Body $body1 -Description "updateMicrotaskStatus"

Write-Host ""

# Teste 2: updateTaskStatus
$body2 = @{
    taskId = $TASK_ID
    status = "in_progress"
}
$result2 = Invoke-CloudFunction -FunctionName "updateTaskStatus" -Body $body2 -Description "updateTaskStatus"

Write-Host ""

# Teste 3: getTaskStatistics
$body3 = @{
    eventId = $EVENT_ID
}
$result3 = Invoke-CloudFunction -FunctionName "getTaskStatistics" -Body $body3 -Description "getTaskStatistics"

Write-Host ""

# Resumo dos resultados
Write-Host "📊 Resumo dos Testes:" -ForegroundColor Magenta
Write-Host "- updateMicrotaskStatus: $(if($result1) {'✅ Sucesso'} else {'❌ Falhou'})" -ForegroundColor $(if($result1) {'Green'} else {'Red'})
Write-Host "- updateTaskStatus: $(if($result2) {'✅ Sucesso'} else {'❌ Falhou'})" -ForegroundColor $(if($result2) {'Green'} else {'Red'})
Write-Host "- getTaskStatistics: $(if($result3) {'✅ Sucesso'} else {'❌ Falhou'})" -ForegroundColor $(if($result3) {'Green'} else {'Red'})

Write-Host ""
Write-Host "💡 Dicas:" -ForegroundColor Yellow
Write-Host "- Verifique os logs no Firebase Console para mais detalhes"
Write-Host "- Se houver erros de autenticação, configure as regras de segurança"
Write-Host "- Para testes com autenticação, adicione o token JWT no header Authorization"
Write-Host "- Verifique se as Cloud Functions estão deployadas corretamente"

Write-Host ""
Write-Host "🔗 Links úteis:"
Write-Host "- Firebase Console: https://console.firebase.google.com/project/$PROJECT_ID"
Write-Host "- Cloud Functions Logs: https://console.firebase.google.com/project/$PROJECT_ID/functions/logs"

Read-Host "Pressione Enter para sair"