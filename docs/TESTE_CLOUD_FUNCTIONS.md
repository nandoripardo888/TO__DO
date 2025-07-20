# 🧪 Guia de Testes para Firebase Cloud Functions

Este guia fornece instruções detalhadas para testar as Firebase Cloud Functions implementadas no projeto ConTask.

## 📋 Pré-requisitos

1. **Firebase CLI instalado e configurado**
   ```bash
   npm install -g firebase-tools
   firebase login
   ```

2. **Cloud Functions deployadas**
   ```bash
   cd functions
   firebase deploy --only functions
   ```

3. **IDs reais do seu projeto**
   - ID do projeto Firebase
   - IDs de usuários, microtasks, tasks e eventos existentes

## 🎯 Métodos de Teste

### 1. Teste via Flutter (Recomendado)

**Arquivo:** `test_cloud_functions.dart`

1. **Configuração:**
   ```dart
   // Edite as constantes no arquivo
   const userId = 'SEU_USER_ID_REAL';
   const microtaskId = 'SEU_MICROTASK_ID_REAL';
   const taskId = 'SEU_TASK_ID_REAL';
   const eventId = 'SEU_EVENT_ID_REAL';
   ```

2. **Execução:**
   ```bash
   flutter run test_cloud_functions.dart
   ```

3. **Vantagens:**
   - Testa a integração completa
   - Usa o mesmo código que a aplicação
   - Inclui tratamento de erros

### 2. Teste via PowerShell (Windows)

**Arquivo:** `test_cloud_functions.ps1`

1. **Configuração:**
   ```powershell
   # Edite as variáveis no arquivo
   $PROJECT_ID = "seu-projeto-firebase"
   $USER_ID = "SEU_USER_ID_REAL"
   # ... outras variáveis
   ```

2. **Execução:**
   ```powershell
   powershell -ExecutionPolicy Bypass -File test_cloud_functions.ps1
   ```

3. **Vantagens:**
   - Testes HTTP diretos
   - Respostas detalhadas
   - Fácil de modificar

### 3. Teste via Batch (Windows)

**Arquivo:** `test_cloud_functions.bat`

1. **Configuração:**
   ```batch
   set PROJECT_ID=seu-projeto-firebase
   set USER_ID=SEU_USER_ID_REAL
   REM ... outras variáveis
   ```

2. **Execução:**
   ```cmd
   test_cloud_functions.bat
   ```

3. **Vantagens:**
   - Simples e direto
   - Usa curl nativo
   - Compatível com qualquer Windows

### 4. Teste via Firebase CLI

```bash
# Teste local (emulador)
firebase emulators:start --only functions

# Teste de uma função específica
firebase functions:shell

# No shell interativo:
updateMicrotaskStatus({userId: 'test', microtaskId: 'test', status: 'in_progress'})
```

## 🔧 Configuração dos IDs de Teste

### Como obter IDs reais:

1. **User ID:**
   - Acesse Firebase Console > Authentication
   - Copie o UID de um usuário existente

2. **Microtask ID:**
   - Acesse Firestore > Coleção `microtasks`
   - Copie o ID de um documento

3. **Task ID:**
   - Acesse Firestore > Coleção `tasks`
   - Copie o ID de um documento

4. **Event ID:**
   - Acesse Firestore > Coleção `events`
   - Copie o ID de um documento

### Exemplo de configuração:

```dart
// test_cloud_functions.dart
const userId = 'abc123def456';
const microtaskId = 'microtask_789xyz';
const taskId = 'task_456abc';
const eventId = 'event_123def';
```

## 📊 Cenários de Teste

### 1. updateMicrotaskStatus

**Cenários válidos:**
```json
{
  "userId": "user123",
  "microtaskId": "microtask456",
  "status": "in_progress"
}
```

**Status válidos:**
- `assigned`
- `in_progress`
- `completed`
- `cancelled`

**Cenários de erro:**
- IDs inexistentes
- Status inválidos
- Transições não permitidas

### 2. updateTaskStatus

**Cenários válidos:**
```json
{
  "taskId": "task123",
  "status": "in_progress"
}
```

**Status válidos:**
- `pending`
- `in_progress`
- `completed`
- `cancelled`

### 3. getTaskStatistics

**Cenários válidos:**
```json
{
  "eventId": "event123"
}
```

**Resposta esperada:**
```json
{
  "totalTasks": 10,
  "completedTasks": 3,
  "inProgressTasks": 4,
  "pendingTasks": 3,
  "totalMicrotasks": 25,
  "completedMicrotasks": 8,
  "completionRate": 32.0
}
```

## 🐛 Troubleshooting

### Erros Comuns:

1. **"Function not found"**
   - Verifique se as funções foram deployadas
   - Confirme o nome da região (us-central1)

2. **"Permission denied"**
   - Configure as regras de segurança do Firestore
   - Verifique autenticação se necessária

3. **"Invalid argument"**
   - Verifique se os IDs existem no Firestore
   - Confirme o formato dos parâmetros

4. **Timeout**
   - Aumente o timeout das requisições
   - Verifique a performance das funções

### Logs e Monitoramento:

1. **Firebase Console:**
   - Functions > Logs
   - Firestore > Usage

2. **Logs locais:**
   ```bash
   firebase functions:log
   ```

3. **Emulador:**
   ```bash
   firebase emulators:start --only functions,firestore
   ```

## 📈 Métricas de Sucesso

### Critérios de Aprovação:

1. **updateMicrotaskStatus:**
   - ✅ Atualiza status corretamente
   - ✅ Propaga para microtask pai
   - ✅ Valida transições de status
   - ✅ Retorna sucesso/erro apropriado

2. **updateTaskStatus:**
   - ✅ Atualiza status da task
   - ✅ Valida status permitidos
   - ✅ Mantém consistência

3. **getTaskStatistics:**
   - ✅ Retorna estatísticas corretas
   - ✅ Calcula percentuais precisos
   - ✅ Performance adequada (<2s)

### Performance Esperada:

- **updateMicrotaskStatus:** < 1s
- **updateTaskStatus:** < 1s  
- **getTaskStatistics:** < 2s
- **Cold start:** < 3s

## 🚀 Próximos Passos

Após os testes bem-sucedidos:

1. **Integração completa:**
   - Substitua todos os métodos locais
   - Remova código legado
   - Atualize documentação

2. **Monitoramento:**
   - Configure alertas
   - Implemente métricas customizadas
   - Monitore custos

3. **Otimização:**
   - Analise performance
   - Otimize consultas
   - Implemente cache se necessário

---

**💡 Dica:** Sempre teste em ambiente de desenvolvimento antes de aplicar em produção!