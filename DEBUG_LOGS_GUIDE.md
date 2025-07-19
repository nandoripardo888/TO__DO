# Guia de Logs de Depuração - Atualização de Status de Microtarefas

## 📋 Visão Geral

Este documento explica como interpretar os logs detalhados adicionados para depurar problemas na atualização de status de microtarefas via stepped na agenda.

## 🔍 Fluxo de Logs

Quando você clica para atualizar o status de uma microtarefa, os logs seguem esta sequência:

### 1. STATUS_STEPPER (Interface do Usuário)
```
👆 [STATUS_STEPPER] Toque detectado:
   - status atual: assigned
   - status clicado: completed
   - _isLoading: false
   - timestamp: 2024-01-15T10:30:00.000Z
```

### 2. AGENDA_SCREEN (Tela Principal)
```
🎯 [AGENDA_SCREEN] Iniciando mudança de status:
   - userMicrotask.userId: user123
   - userMicrotask.microtaskId: microtask456
   - status atual: inProgress
   - novo status: completed
   - timestamp: 2024-01-15T10:30:00.100Z
```

### 3. AGENDA (Controller)
```
🔄 [AGENDA] Iniciando atualização de status:
   - userId: user123
   - microtaskId: microtask456
   - status: completed
   - timestamp: 2024-01-15T10:30:00.200Z
```

### 4. REPOSITORY (Camada de Dados)
```
📦 [REPOSITORY] Validando parâmetros:
   - userId: "user123" (isEmpty: false)
   - microtaskId: "microtask456" (isEmpty: false)
   - status: completed

✅ [REPOSITORY] Validação passou, chamando CloudFunctionsService...
```

### 5. CLOUD_FUNCTIONS (Serviço de Cloud Functions)
```
☁️ [CLOUD_FUNCTIONS] Preparando chamada updateMicrotaskStatus:
   - userId: "user123"
   - microtaskId: "microtask456"
   - newStatus: "completed"

📞 [CLOUD_FUNCTIONS] Callable criado, fazendo chamada...
📤 [CLOUD_FUNCTIONS] Payload: {userId: user123, microtaskId: microtask456, newStatus: completed}
📥 [CLOUD_FUNCTIONS] Resposta recebida:
   - result.data: {success: true}
   - result.data type: _Map<String, dynamic>
✅ [CLOUD_FUNCTIONS] Success extraído: true
```

## 🚨 Identificando Problemas

### Problema 1: Validação de Parâmetros
```
❌ [REPOSITORY] Validação falhou: ID do usuário é obrigatório
```
**Solução:** Verificar se o userId está sendo passado corretamente.

### Problema 2: Erro na Cloud Function
```
❌ [CLOUD_FUNCTIONS] FirebaseFunctionsException:
   - code: unauthenticated
   - message: Request is missing required authentication credential
   - details: null
```
**Solução:** Verificar autenticação do Firebase.

### Problema 3: Erro de Rede
```
❌ [CLOUD_FUNCTIONS] Erro inesperado:
   - Tipo: SocketException
   - Mensagem: Failed host lookup: 'firebase.googleapis.com'
```
**Solução:** Verificar conexão com a internet.

### Problema 4: Transição de Status Inválida
```
🚫 [STATUS_STEPPER] Transição inválida: assigned -> completed
```
**Solução:** O usuário tentou pular uma etapa. Status deve seguir: assigned → inProgress → completed.

## 🔍 Problemas Comuns e Soluções

### Problema 5: "User microtask não encontrada"
```
❌ [CLOUD_FUNCTIONS] Erro interno: User microtask não encontrada
```
**Sintomas:** Erro interno na Cloud Function com código `internal`
**Causa identificada:** Nomes de campos incorretos na Cloud Function

**Problema:** A Cloud Function estava usando nomes de campos em snake_case (`user_id`, `microtask_id`, `task_id`) enquanto o Firestore usa camelCase (`userId`, `microtaskId`, `taskId`).

**Solução aplicada:** 
- ✅ Corrigido: `userId`, `microtaskId`, `taskId` (camelCase)
- ❌ Anterior: `user_id`, `microtask_id`, `task_id` (snake_case)

**Como verificar:** Após a correção, os logs devem mostrar:
```
📥 [CLOUD_FUNCTIONS] Resposta recebida:
   - result.data: {success: true}
✅ [CLOUD_FUNCTIONS] Success extraído: true
```

## 📊 Emojis dos Logs

| Emoji | Significado |
|-------|-------------|
| 👆 | Interação do usuário (toque) |
| 🎯 | Início de operação na tela |
| 🔄 | Processamento/atualização |
| 📦 | Operação no repositório |
| ☁️ | Chamada para Cloud Functions |
| 📞 | Criação de callable |
| 📤 | Envio de dados |
| 📥 | Recebimento de resposta |
| ✅ | Sucesso |
| ❌ | Erro |
| 🚫 | Operação bloqueada/inválida |
| ⏳ | Aguardando/carregando |
| 💬 | Resposta de diálogo |
| 🏁 | Finalização |
| ⚠️ | Aviso |

## 🔧 Como Usar

1. **Reproduza o erro:** Tente atualizar o status da microtarefa novamente
2. **Abra o console:** No VS Code, vá em "Debug Console" ou "Terminal"
3. **Procure pelos logs:** Use Ctrl+F para buscar por "[STATUS_STEPPER]", "[AGENDA]", etc.
4. **Identifique onde parou:** Veja qual foi o último log de sucesso (✅) antes do erro (❌)
5. **Analise o erro:** Leia a mensagem de erro detalhada
6. **Compare com este guia:** Use a seção "Identificando Problemas" para encontrar a solução

## 📝 Exemplo de Sessão de Debug

```
👆 [STATUS_STEPPER] Toque detectado:
   - status atual: inProgress
   - status clicado: completed
🔄 [STATUS_STEPPER] Transição válida: inProgress -> completed
💬 [STATUS_STEPPER] Resposta do diálogo de confirmação: true
✅ [STATUS_STEPPER] Iniciando mudança de status para: completed
📞 [STATUS_STEPPER] Chamando callback onStatusChanged...
🎯 [AGENDA_SCREEN] Iniciando mudança de status:
   - userMicrotask.userId: user123
   - userMicrotask.microtaskId: microtask456
🔄 [AGENDA] Iniciando atualização de status:
   - userId: user123
   - microtaskId: microtask456
   - status: completed
📦 [REPOSITORY] Validando parâmetros:
   - userId: "user123" (isEmpty: false)
   - microtaskId: "microtask456" (isEmpty: false)
✅ [REPOSITORY] Validação passou, chamando CloudFunctionsService...
☁️ [CLOUD_FUNCTIONS] Preparando chamada updateMicrotaskStatus:
❌ [CLOUD_FUNCTIONS] FirebaseFunctionsException:
   - code: not-found
   - message: Function updateMicrotaskStatus not found
```

**Diagnóstico:** A Cloud Function não foi encontrada. Verificar se ela foi deployada corretamente.

## 🎯 Próximos Passos

Após identificar o problema com os logs:

1. **Corrija o problema identificado**
2. **Teste novamente**
3. **Verifique se os logs mostram sucesso em todas as etapas**
4. **Se necessário, adicione mais logs específicos**

---

**Nota:** Estes logs são temporários para depuração. Após resolver o problema, considere remover ou reduzir a verbosidade dos logs para produção.