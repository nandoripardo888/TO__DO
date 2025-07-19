# Firebase Cloud Functions - ConTask

## Visão Geral

Este documento descreve as Firebase Cloud Functions implementadas no projeto ConTask para gerenciamento de status de Tasks e MicroTasks.

## Arquitetura

### Estrutura de Arquivos
```
functions/
├── index.js              # Funções principais
├── package.json          # Dependências Node.js
├── .eslintrc.js         # Configuração ESLint
└── README.md            # Documentação das funções
```

### Configuração Firebase
O arquivo `firebase.json` foi atualizado para incluir:
```json
{
  "functions": {
    "source": "functions",
    "runtime": "nodejs18"
  }
}
```

## Funções Implementadas

### 1. updateMicrotaskStatus (Callable)
**Propósito:** Atualiza o status de uma microtask para um usuário específico.

**Validações:**
- Parâmetros obrigatórios
- Status válidos (assigned, in_progress, completed)
- Prevenção de regressão de status
- Existência da user_microtask

**Fluxo:**
1. Valida parâmetros de entrada
2. Busca a user_microtask no Firestore
3. Valida transição de status (sem regressão)
4. Atualiza o documento com timestamp
5. Retorna resultado da operação

### 2. updateTaskStatus (Callable)
**Propósito:** Atualiza o status de uma task.

**Validações:**
- Parâmetros obrigatórios
- Status válidos (pending, in_progress, completed)
- Prevenção de regressão de status
- Existência da task

### 3. onUserMicrotaskStatusChange (Trigger)
**Propósito:** Propagação automática de status quando user_microtask é atualizada.

**Lógica de Propagação:**

#### Para MicroTask:
- **assigned**: Todos os voluntários estão "assigned"
- **in_progress**: Pelo menos um voluntário iniciou
- **completed**: Todos os voluntários completaram

#### Para Task (pai):
- **pending**: Todas as microtasks estão "assigned"
- **in_progress**: Pelo menos uma microtask iniciou
- **completed**: Todas as microtasks foram completadas

### 4. getTaskStatistics (Callable)
**Propósito:** Retorna estatísticas detalhadas de uma task.

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

## Integração com Flutter

### Dependência Adicionada
```yaml
dependencies:
  cloud_functions: ^5.0.0
```

### Serviço Flutter
Criado `CloudFunctionsService` em `lib/data/services/cloud_functions_service.dart`:

```dart
// Exemplo de uso
final cloudFunctions = CloudFunctionsService();

// Atualizar status de microtask
final success = await cloudFunctions.updateMicrotaskStatus(
  microtaskId: 'microtask_123',
  newStatus: 'in_progress',
  userId: 'user_456',
);

// Obter estatísticas
final stats = await cloudFunctions.getTaskStatistics('task_123');
print('Progresso: ${stats.progressPercentage}%');
```

### Integração no Repository
Adicionado método alternativo no `UserMicrotaskRepository`:

```dart
// Método tradicional (direto no Firestore)
await repository.updateUserMicrotaskStatus(...);

// Método com Cloud Functions (recomendado para operações críticas)
await repository.updateUserMicrotaskStatusWithCloudFunction(...);
```

## Vantagens das Cloud Functions

### 1. Consistência de Dados
- Validação centralizada no servidor
- Propagação automática de status
- Transações atômicas

### 2. Segurança
- Validações server-side
- Prevenção de manipulação client-side
- Auditoria centralizada

### 3. Performance
- Redução de lógica complexa no cliente
- Operações otimizadas no servidor
- Menos round-trips para o banco

### 4. Manutenibilidade
- Lógica de negócio centralizada
- Facilita atualizações de regras
- Debugging centralizado

## Regras de Negócio Implementadas

### RN-03.3: Progressão de Status
- **MicroTasks:** assigned → in_progress → completed
- **Tasks:** pending → in_progress → completed
- Apenas progressão para frente é permitida

### RN-03.4: Validação de Fluxo
- Impede qualquer tipo de regressão
- Validação tanto no cliente quanto no servidor
- Mensagens de erro descritivas

### RN-04: Propagação Hierárquica
- Status de user_microtasks afeta microtasks
- Status de microtasks afeta tasks
- Cálculo automático baseado em agregação

## Monitoramento e Logs

### Logs Disponíveis
- Todas as operações são logadas
- Erros detalhados para debugging
- Métricas de performance

### Comandos Úteis
```bash
# Ver logs em tempo real
firebase functions:log

# Deploy das funções
firebase deploy --only functions

# Executar localmente
cd functions && npm run serve
```

## Tratamento de Erros

### Tipos de Erro
1. **Validação:** Parâmetros inválidos ou ausentes
2. **Negócio:** Violação de regras (ex: regressão de status)
3. **Sistema:** Erros de conectividade ou Firestore

### Estrutura de Resposta de Erro
```json
{
  "error": {
    "message": "Descrição do erro",
    "code": "INVALID_ARGUMENT"
  }
}
```

## Próximos Passos

### Funcionalidades Futuras
1. **Notificações:** Trigger para envio de notificações
2. **Relatórios:** Geração automática de relatórios
3. **Backup:** Backup automático de dados críticos
4. **Analytics:** Coleta de métricas de uso

### Otimizações
1. **Cache:** Implementar cache para consultas frequentes
2. **Batch Operations:** Operações em lote para performance
3. **Retry Logic:** Lógica de retry para operações críticas

## Considerações de Segurança

### Autenticação
- Todas as callable functions verificam autenticação
- Validação de permissões por usuário
- Prevenção de acesso não autorizado

### Validação de Dados
- Sanitização de inputs
- Validação de tipos e formatos
- Prevenção de injection attacks

### Auditoria
- Log de todas as operações
- Rastreamento de mudanças
- Identificação de usuários