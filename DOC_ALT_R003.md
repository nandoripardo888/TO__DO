# PRD: Funcionalidade - Aba Agenda do Voluntário

**Documento de Requisitos do Produto (PRD)**
**Projeto:** Task Manager para Eventos - ConTask
**Funcionalidade:** Aba "AGENDA" para Voluntários

---

## Informações do Documento

| Campo | Valor |
|-------|-------|
| **Documento** | PRD - Nova Funcionalidade |
| **Status** | Em Desenvolvimento |
| **Recurso** | Aba "AGENDA" de Microtarefas do Voluntário |
| **Autor** | Equipe de Desenvolvimento |
| **Data** | 16/07/2025 |
| **Versão** | 1.1 |
| **Projeto** | ConTask - Task Manager para Eventos |

### 1\. Resumo e Objetivo

Este documento especifica os requisitos para a criação de uma nova aba "AGENDA" na tela de detalhes do evento. O objetivo principal é fornecer aos voluntários uma visão pessoal, clara e acionável de todas as microtarefas que lhes foram atribuídas dentro de um evento específico. A funcionalidade permitirá que os voluntários atualizem seu progresso individual, e o sistema usará essa informação para automatizar a atualização do status geral das microtarefas e tarefas.

### 2\. Justificativa

Atualmente, o voluntário tem uma visão dispersa de suas atribuições, geralmente na tela "Acompanhar Tasks", que mostra todas as tarefas do evento. Não há um local centralizado para o voluntário ver apenas _suas_ responsabilidades e gerenciar seu progresso de forma simples.

Esta funcionalidade irá:

*   **Melhorar a Experiência do Voluntário (UX):** Cria uma "to-do list" pessoal e intuitiva, reduzindo a carga cognitiva e deixando claro o que precisa ser feito.
    
*   **Aumentar o Engajamento:** Facilita a interação do voluntário com suas tarefas, incentivando a atualização de status em tempo real.
    
*   **Automatizar o Acompanhamento:** Reduz a necessidade de o gerente verificar manualmente o progresso com cada voluntário. O status das tarefas na visão gerencial será um reflexo fiel do trabalho que está sendo realizado.
    
*   **Melhorar a Integridade dos Dados:** O status geral das tarefas (`in_progress`, `completed`) será mais preciso e confiável.
    

### 3\. Requisitos Funcionais Detalhados

#### REQ-01: Nova Aba "AGENDA"

*   **Descrição:** Uma nova aba chamada **"AGENDA"** deve ser adicionada à tela de detalhes do evento para fornecer aos voluntários uma visão personalizada de suas microtarefas.

*   **Regras de Negócio:**

    *   **RN-01.1 - Posicionamento:** A aba "AGENDA" deve ser inserida na `TabBar` da tela `event_details_screen.dart`, seguindo a ordem: "Evento" → "AGENDA" → "Perfil" → "Acompanhar".

    *   **RN-01.2 - Visibilidade:** A aba deve ser visível **apenas** para usuários que estão na lista `volunteers` do evento, seguindo o padrão de tabs dinâmicas estabelecido (RN-02 da especificação geral).

    *   **RN-01.3 - Conteúdo:** A aba deve listar verticalmente todas as microtarefas atribuídas ao usuário logado para aquele evento específico.

    *   **RN-01.4 - Fonte de Dados:** A lista deve ser obtida consultando a collection `user_microtasks` com filtros: `userId == currentUser.id AND eventId == currentEvent.id`.

    *   **RN-01.5 - Ordenação:** As microtarefas devem ser ordenadas por: 1) Status (assigned → in_progress → completed), 2) Data de atribuição (assignedAt).
        

#### REQ-02: Componente da Microtarefa (Card da Agenda)

*   **Descrição:** Cada item na lista da agenda será um componente de card reutilizável (`microtask_agenda_card.dart`) com design limpo e funcional, focado na ação do usuário.

*   **Estrutura do Card:**

    *   **RN-02.1 - Título da Microtarefa:** Texto em destaque usando estilo de título (font weight bold, cor #374151).

    *   **RN-02.2 - Título da Tarefa Pai:** Logo abaixo, com menor destaque (ex: "Pertence a: Limpeza da Área Leste"), usando cor secundária #A78BFA.

    *   **RN-02.3 - Informações Temporais:** Data/hora da microtarefa formatada como "dd/mm/yyyy HH:MM - HH:MM" (campos `startDateTime`, `endDateTime` do model `microtask_model`).

    *   **RN-02.4 - Status Stepper Horizontal:** Na parte inferior do card, controle de status com 3 estados dispostos horizontalmente.

    *   **RN-02.5 - Responsividade:** Card deve adaptar-se a diferentes tamanhos de tela mantendo legibilidade.
        
*   **Design do Status Stepper:**
    
    *   **Assigned (Atribuída):** Círculo com contorno e o número 1 dentro. Será o estado padrão e não interativo.
        
    *   **In Progress (Em Andamento):** Círculo com contorno e o número 2 dentro. Torna-se interativo.
        
    *   **Completed (Concluída):** Círculo com contorno e um ícone de "check" (✓) dentro. Torna-se interativo.
        
    *   **Visual do Progresso:** Uma linha conectará os círculos. Quando um status é selecionado, o círculo e a linha até ele são preenchidos com a cor principal (#6B46C1 - Roxo), e os números/ícones ficam brancos, seguindo o Design System estabelecido.
        

#### REQ-03: Lógica de Interação do Usuário na Agenda

*   **Descrição:** Define como o voluntário interage com o Status Stepper no card, incluindo validações e feedback visual.

*   **Regras de Negócio:**

    *   **RN-03.1 - Escopo de Atualização:** A ação do usuário (clicar em um status) deve atualizar **apenas o seu próprio status** na collection `user_microtasks`. O campo `status` do documento `user_microtask` correspondente deve ser modificado.

    *   **RN-03.2 - Estado Inicial:** O status `assigned` é o estado inicial (não interativo) e não pode ser selecionado pelo usuário.

    *   **RN-03.3 - Progressão Permitida:** O usuário pode marcar `in_progress` a partir de `assigned`, e `completed` a partir de `in_progress`.

    *   **RN-03.4 - Regressão Permitida:** O usuário pode desmarcar `completed` (voltando para `in_progress`) ou desmarcar `in_progress` (voltando para `assigned`).

    *   **RN-03.5 - Validação de Fluxo:** A lógica deve impedir transição direta de `completed` para `assigned` (deve passar por `in_progress`).

    *   **RN-03.6 - Feedback Visual:** Cada mudança de status deve fornecer feedback visual imediato (loading, sucesso, erro).

    *   **RN-03.7 - Timestamps:** Atualizar campos `startedAt` (ao marcar in_progress) e `completedAt` (ao marcar completed).
        

#### REQ-04: Lógica de Propagação de Status (Backend/Cloud Functions)

*   **Descrição:** Define as regras de negócio automáticas que ocorrem em cascata quando um voluntário atualiza seu status. **Esta lógica é crítica e deve ser implementada via Cloud Functions ou transações no backend para garantir a consistência dos dados.**

*   **Regras de Negócio:**

    *   **RN-04.1 - Microtarefa para "Em Andamento":** Quando **pelo menos 1** voluntário de uma microtarefa atualiza seu status em `user_microtasks` para `in_progress`, o status do documento principal na collection `microtasks` deve ser automaticamente alterado para `in_progress`.

    *   **RN-04.2 - Tarefa para "Em Andamento":** Se o status de uma `microtask` muda para `in_progress` (conforme RN-04.1), o status de sua `task` pai na collection `tasks` também deve ser alterado para `in_progress`.

    *   **RN-04.3 - Microtarefa para "Concluída":** Quando **todos** os voluntários listados no campo `assignedTo` da `microtask` tiverem seus respectivos documentos em `user_microtasks` com o status `completed`, o status do documento principal na collection `microtasks` deve ser alterado para `completed`.

    *   **RN-04.4 - Tarefa para "Concluída":** Quando **todas** as `microtasks` pertencentes a uma `task` estiverem com o status `completed`, o status do documento da `task` pai na collection `tasks` deve ser alterado para `completed`.

    *   **RN-04.5 - Atomicidade:** Todas as operações de propagação devem ser atômicas para evitar estados inconsistentes.

    *   **RN-04.6 - Auditoria:** Registrar logs de todas as mudanças de status para rastreabilidade.
        

### 4\. Design System e Especificações Visuais

#### 4.1 Cores e Estilo
Seguindo o Design System estabelecido na especificação geral:
- **Cor Principal:** #6B46C1 (Roxo)
- **Cor Secundária:** #A78BFA (Roxo claro)
- **Cor de Fundo:** #FFFFFF (Branco)
- **Cor de Texto:** #374151 (Cinza escuro)
- **Cor de Sucesso:** #10B981 (Verde)
- **Estilo:** Clean, minimalista, Material Design

#### 4.2 Proposta de Design (Componente da Agenda)

Abaixo, uma maquete textual do card proposto:

+-------------------------------------------------------------+
    |                                                             |
    |  [Título da Microtarefa em negrito]                         |
    |  <Pertence a: Título da Tarefa Pai>                         |
    |  <Icone Calendario> dd/mm/yyyy HH:MM - HH:MM                 |
    |                                                             |
    |  ---------------------------------------------------------  |
    |                                                             |
    |   ( 1 ) --------- O --------- O                             |
    |  Atribuída     Em Andamento  Concluída                      |
    |                                                             |
    +-------------------------------------------------------------+

_Estado "Em Andamento":_

|   / 1 \ -------- / 2 \ -------- O                             |
    |  Atribuída     Em Andamento  Concluída                      |

_(Onde `/ \` representa um círculo preenchido)_

### 5\. Modelos de Dados Envolvidos

Esta funcionalidade interage com os seguintes modelos definidos na especificação geral:

#### 5.1 Collections Firestore Utilizadas

**user_microtasks** (Principal):
```json
{
  "id": "user_microtask_id",
  "userId": "user_id",
  "microtaskId": "microtask_id",
  "eventId": "event_id",
  "status": "assigned|in_progress|completed",
  "assignedAt": "timestamp",
  "startedAt": "timestamp",
  "completedAt": "timestamp",
  "actualHours": 0.0,
  "notes": "Observações do voluntário"
}
```

**microtasks** (Para informações da microtarefa):
```json
{
  "id": "microtask_id",
  "taskId": "task_id",
  "title": "Título da Microtarefa",
  "startDateTime": "timestamp",
  "endDateTime": "timestamp",
  "status": "pending|assigned|in_progress|completed|cancelled"
}
```

**tasks** (Para informações da tarefa pai):
```json
{
  "id": "task_id",
  "title": "Título da Tarefa",
  "status": "pending|in_progress|completed"
}
```

#### 5.2 Queries Necessárias
- **Agenda do Voluntário:** `user_microtasks.where('userId', '==', currentUser.id).where('eventId', '==', currentEvent.id)`
- **Dados da Microtarefa:** `microtasks.doc(microtaskId).get()`
- **Dados da Tarefa Pai:** `tasks.doc(taskId).get()`

### 6\. Análise de Impacto

#### 6.1 Impacto no Banco de Dados (Firestore)

**Queries Necessárias:**
- **Principal:** `user_microtasks.where('userId', '==', currentUser.id).where('eventId', '==', currentEvent.id).orderBy('assignedAt')`
- **Joins necessários:** Buscar dados de `microtasks` e `tasks` para cada item da agenda
- **Índices recomendados:** Criar índice composto em `user_microtasks` para `(userId, eventId, assignedAt)`

**Estimativa de Performance:**
- **Leitura:** ~10-50 documentos por usuário por evento (baixo impacto)
- **Escrita:** 1 documento por mudança de status + propagação em cascata
- **Custo:** Baixo a médio, dependendo da frequência de atualizações

#### 6.2 Impacto no Código da Aplicação

**Arquivos Modificados:**
```
lib/presentation/screens/event/event_details_screen.dart
├── Adicionar Tab "AGENDA" na TabBar dinâmica
├── Implementar lógica de visibilidade baseada em permissões
└── Integrar com AgendaController

lib/presentation/controllers/task_controller.dart
├── Adicionar métodos para buscar user_microtasks
└── Integrar com agenda_controller para sincronização

lib/data/services/task/microtask_service.dart
├── updateUserMicrotaskStatus(userMicrotaskId, newStatus)
├── getUserMicrotasksByEvent(userId, eventId)
└── Métodos para propagação de status
```

**Arquivos Criados:**
```
lib/presentation/screens/agenda/
├── agenda_screen.dart (Tela principal da aba)
└── widgets/
    └── microtask_agenda_card.dart (Componente reutilizável)

lib/presentation/controllers/
└── agenda_controller.dart (Gerenciamento de estado específico)

lib/data/repositories/volunteer/
└── user_microtask_repository.dart (Abstração de dados)

lib/data/models/volunteer/
└── user_microtask_model.dart (Se não existir)
```

#### 6.3 Serviços de Backend (Cloud Functions)

**Funções Recomendadas:**
```javascript
// functions/src/statusPropagation.js
exports.onUserMicrotaskStatusChange = functions.firestore
  .document('user_microtasks/{docId}')
  .onUpdate(async (change, context) => {
    // Lógica de propagação RN-04.1 a RN-04.4
  });
```

**Benefícios:**
- Garantia de consistência de dados
- Redução de lógica complexa no cliente
- Auditoria centralizada de mudanças
        

### 7\. Considerações de Implementação

#### 7.1 Arquitetura e Padrões
- **Controller Pattern:** Utilizar `agenda_controller.dart` seguindo padrão GetX/Provider estabelecido
- **Repository Pattern:** Implementar `user_microtask_repository.dart` para abstração de dados
- **Service Layer:** Estender `microtask_service.dart` com métodos específicos da agenda
- **Widget Reutilizável:** `microtask_agenda_card.dart` deve ser componentizado e reutilizável

#### 7.2 Performance e Otimização
- **Paginação:** Implementar para listas grandes de microtarefas
- **Cache Local:** Armazenar dados da agenda para acesso offline
- **Queries Otimizadas:** Usar índices compostos no Firestore para melhor performance
- **Real-time Updates:** Implementar listeners para atualizações em tempo real

#### 7.3 Tratamento de Erros
- **Conectividade:** Tratar cenários offline/online
- **Permissões:** Validar acesso do usuário antes de exibir dados
- **Estados de Loading:** Implementar indicadores visuais durante carregamento
- **Fallbacks:** Definir comportamentos para casos de erro

### 8\. Critérios de Aceite

| ID | Critério | Verificação | Prioridade |
| --- | --- | --- | --- |
| **AC-01** | **Visibilidade da Aba** | A aba "AGENDA" está visível na tela de detalhes do evento apenas para usuários que estão na lista `volunteers` do evento. | Alta |
| **AC-02** | **Conteúdo da Agenda** | A aba "AGENDA" lista todos (e somente) os cards das microtarefas atribuídas ao usuário logado para aquele evento específico. | Alta |
| **AC-03** | **Estrutura do Card** | Cada card na agenda exibe: título da microtarefa, tarefa pai ("Pertence a: X"), data/hora (se disponível) e stepper de status horizontal. | Alta |
| **AC-04** | **Ordenação** | As microtarefas são exibidas ordenadas por status (assigned → in_progress → completed) e depois por data de atribuição. | Média |
| **AC-05** | **Interação - Em Andamento** | Ao clicar no check "Em Andamento", o status em `user_microtasks` é atualizado para `in_progress` e o visual do card reflete a mudança imediatamente. | Alta |
| **AC-06** | **Interação - Concluída** | Ao clicar no check "Concluída", o status em `user_microtasks` é atualizado para `completed` e `completedAt` é preenchido. | Alta |
| **AC-07** | **Regressão de Status** | O usuário pode desmarcar status seguindo o fluxo: completed → in_progress → assigned (sem pular etapas). | Média |
| **AC-08** | **Feedback Visual** | Cada mudança de status exibe loading durante processamento e feedback de sucesso/erro. | Média |
| **AC-09** | **Propagação - Microtarefa In Progress** | Quando o 1º voluntário marca "Em Andamento", o status da microtarefa muda para `in_progress`. | Alta |
| **AC-10** | **Propagação - Tarefa In Progress** | Quando uma microtarefa fica "Em Andamento", sua tarefa pai também fica "Em Andamento". | Alta |
| **AC-11** | **Propagação - Microtarefa Completed** | O status de uma microtarefa só muda para `completed` depois que todos os voluntários atribuídos marcarem "Concluída". | Alta |
| **AC-12** | **Propagação - Tarefa Completed** | O status de uma tarefa só muda para `completed` depois que todas as suas microtarefas estiverem "Concluídas". | Alta |
| **AC-13** | **Responsividade** | A interface se adapta corretamente a diferentes tamanhos de tela mantendo usabilidade. | Baixa |
| **AC-14** | **Performance** | A aba carrega em menos de 2 segundos com até 50 microtarefas. | Média |

