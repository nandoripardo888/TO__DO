# Firebase Cloud Functions - ConTask

Este diretório contém as Firebase Cloud Functions para o projeto ConTask.

## Funções Disponíveis

### 1. updateMicrotaskStatus
**Tipo:** Callable Function  
**Descrição:** Atualiza o status de uma microtask específica para um usuário.

**Parâmetros:**
- `microtaskId` (string): ID da microtask
- `newStatus` (string): Novo status ("assigned", "in_progress", "completed")
- `userId` (string): ID do usuário

**Exemplo de uso no Flutter:**
```dart
final callable = FirebaseFunctions.instance.httpsCallable('updateMicrotaskStatus');
final result = await callable.call({
  'microtaskId': 'microtask_123',
  'newStatus': 'in_progress',
  'userId': 'user_456'
});
```

### 2. updateTaskStatus
**Tipo:** Callable Function  
**Descrição:** Atualiza o status de uma task.

**Parâmetros:**
- `taskId` (string): ID da task
- `newStatus` (string): Novo status ("pending", "in_progress", "completed")

**Exemplo de uso no Flutter:**
```dart
final callable = FirebaseFunctions.instance.httpsCallable('updateTaskStatus');
final result = await callable.call({
  'taskId': 'task_123',
  'newStatus': 'completed'
});
```

### 3. onUserMicrotaskStatusChange
**Tipo:** Firestore Trigger  
**Descrição:** Trigger automático que é executado quando uma user_microtask é atualizada. Propaga automaticamente as mudanças de status para a microtask pai e task pai.

**Lógica de Propagação:**
- **Microtask Status:**
  - `assigned`: Todos os voluntários estão com status "assigned"
  - `in_progress`: Pelo menos um voluntário iniciou ("in_progress" ou "completed")
  - `completed`: Todos os voluntários completaram

- **Task Status:**
  - `pending`: Todas as microtasks estão "assigned"
  - `in_progress`: Pelo menos uma microtask iniciou
  - `completed`: Todas as microtasks foram completadas

### 4. getTaskStatistics
**Tipo:** Callable Function  
**Descrição:** Retorna estatísticas de uma task (contadores de microtasks por status).

**Parâmetros:**
- `taskId` (string): ID da task

**Retorno:**
```json
{
  "success": true,
  "taskId": "task_123",
  "statistics": {
    "total": 10,
    "pending": 2,
    "assigned": 3,
    "in_progress": 4,
    "completed": 1
  }
}
```

## Regras de Negócio Implementadas

### Validação de Status
- **Não Regressão:** As funções impedem que o status regrida (ex: de "completed" para "in_progress")
- **Status Válidos:** 
  - MicroTasks: "assigned", "in_progress", "completed"
  - Tasks: "pending", "in_progress", "completed"

### Propagação Automática
- Mudanças em user_microtasks são automaticamente propagadas para microtasks
- Mudanças em microtasks são automaticamente propagadas para tasks
- Timestamps são atualizados automaticamente

## Instalação e Deploy

### Pré-requisitos
- Node.js 18+
- Firebase CLI
- Projeto Firebase configurado

### Comandos
```bash
# Instalar dependências
cd functions
npm install

# Executar localmente
npm run serve

# Deploy para produção
npm run deploy

# Ver logs
npm run logs
```

## Estrutura de Arquivos
```
functions/
├── index.js          # Funções principais
├── package.json      # Dependências e scripts
├── .eslintrc.js      # Configuração do ESLint
└── README.md         # Esta documentação
```

## Monitoramento

Todas as funções incluem logging detalhado que pode ser visualizado no Firebase Console ou através do comando `npm run logs`.

## Tratamento de Erros

Todas as funções incluem tratamento robusto de erros com mensagens descritivas para facilitar o debugging.