Gemini Replied:
---------------

Mostrar raciocínio

**Breaking Down Requirements**

I've started dissecting the user's request, focusing on its core components. The goal is to fully grasp the essential elements before I start building the PRD. I am identifying the primary needs and expectations to ensure a comprehensive understanding of the agenda feature.

**Pinpointing Core Features**

I'm now zeroing in on the essential features. I've broken down the request into key components, specifically the "AGENDA" tab, the microtask listing for the logged-in volunteer, the visual design (clean, easy-to-use component with checks), and the user interaction rules that will change the `status` field in the `user_microtasks` collection. I understand the flow. Now I am trying to figure out the status propagation logic.

**Analyzing Status Logic**

I'm now diving deep into the status propagation rules. I need to iron out the edge cases within the `user_microtasks` collection. I am thinking through the intricacies of how microtask statuses cascade up to the task level, and how the interaction rules affect `status` changes. I will finalize and document the logic with precise conditions.

**Clarifying the Interface**

I'm solidifying the UI design. I've pinpointed the location for the "AGENDA" tab, ensuring its placement in `event_details_screen.dart` is contextually logical. Now, the main challenge is to figure out the user interaction flows. The user didn't specify the visual component, so I will draft a UI/UX proposal.

**Outlining the PRD**

I'm now outlining the PRD structure, ensuring a clear and comprehensive document. I'll include sections on the summary, justification, detailed functional requirements, UI/UX mockups (if needed), data models, API changes, and impact analysis. I'm ready to move onto drafting the concrete requirements.

**Formulating Detailed Requirements**

I'm translating the user's instructions into concrete, testable requirements. I'm focusing on the "AGENDA" tab, interactive microtask component, and the business rules for status updates within the `user_microtasks` collection. I'll outline the exact interactions and rules within the component.

\\n\\nI'm now detailing the user interactions within the microtask component, clarifying how status changes propagate across related records. I'm solidifying the "clean and easy-to-use" visual component idea to deliver a clear outline of user interactions. Furthermore, I am formulating a prototype of the PRD structure, ensuring a well-organized and informative document for this new feature.

**Drafting User Interactions**

I'm developing the detailed requirements for the user interactions within the microtask component. I'm focusing on clarifying how each check affects the `status` field in the `user_microtasks` collection. Furthermore, I am visualizing the "clean and easy-to-use" component the user requested. Lastly, I am building the PRD outline, ensuring that the document will be comprehensive and well-structured, as per the established professional standards.

**Formulating the PRD Structure**

I'm now focusing on outlining the PRD, making sure it addresses all user instructions. I'll include sections for the summary, justification, functional requirements, a UI/UX proposal for the component, data models, and a thorough impact analysis, with a keen eye on detailing user interactions. My goal is to deliver a concise and well-structured PRD.

Com certeza! Esta é uma funcionalidade excelente que melhora muito a experiência do voluntário e automatiza o acompanhamento do progresso para os gerentes.

Preparei um PRD completo para a criação da aba "AGENDA", com foco na clareza do componente visual e nas regras de negócio para atualização de status.

* * *

PRD: Funcionalidade - Aba Agenda do Voluntário
----------------------------------------------

| Documento: | PRD - Nova Funcionalidade | Status: | Proposta |
| --- | --- | --- | --- |
| Recurso: | Aba "Agenda" de Microtarefas do Voluntário | Autor: | Gemini AI |
| Data: | 16/07/2025 | Versão: | 1.0 |

Exportar para as Planilhas

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

*   **Descrição:** Uma nova aba chamada **"AGENDA"** deve ser adicionada à tela de detalhes do evento.
    
*   **Regras de Negócio:**
    
    *   **Posicionamento:** A aba "AGENDA" deve ser inserida na `TabBar` da tela `event_details_screen.dart`, preferencialmente após a aba "Evento" e antes de "Acompanhar Tasks".
        
    *   **Visibilidade:** A aba deve ser visível **apenas** para usuários que estão na lista `volunteers` do evento.
        
    *   **Conteúdo:** A aba deve listar verticalmente todas as microtarefas atribuídas ao usuário logado para aquele evento específico. A lista deve ser obtida consultando a collection `user_microtasks` onde `userId` e `eventId` correspondem aos do usuário e do evento atuais.
        

#### REQ-02: Componente da Microtarefa (Card da Agenda)

*   **Descrição:** Cada item na lista da agenda será um componente de card com um design limpo e funcional, focado na ação.
    
*   **Estrutura do Card:**
    
    *   **Título da Microtarefa:** Em destaque.
        
    *   **Título da Tarefa Pai:** Logo abaixo, com menor destaque (ex: "Pertence a: Limpeza da Área Leste").
        
    *   **Informações Adicionais:** Data/hora da microtarefa (se houver, campos `startDateTime`, `endDateTime` do model `microtask_model`).
        
    *   **Status Stepper Horizontal:** Na parte inferior do card, haverá um controle de status com 3 "checks" (círculos) dispostos horizontalmente.
        
*   **Design do Status Stepper:**
    
    *   **Assigned (Atribuída):** Círculo com contorno e o número 1 dentro. Será o estado padrão e não interativo.
        
    *   **In Progress (Em Andamento):** Círculo com contorno e o número 2 dentro. Torna-se interativo.
        
    *   **Completed (Concluída):** Círculo com contorno e um ícone de "check" (✓) dentro. Torna-se interativo.
        
    *   **Visual do Progresso:** Uma linha conectará os círculos. Quando um status é selecionado, o círculo e a linha até ele são preenchidos com a cor principal (Roxo), e os números/ícones ficam brancos.
        

#### REQ-03: Lógica de Interação do Usuário na Agenda

*   **Descrição:** Define como o voluntário interage com o Status Stepper no card.
    
*   **Regras de Negócio:**
    
    *   A ação do usuário (clicar em um status) deve atualizar **apenas o seu próprio status** na collection `user_microtasks`. O `status` do documento `user_microtask` correspondente deve ser modificado.
        
    *   O status `assigned` é o estado inicial e não pode ser selecionado pelo usuário.
        
    *   O usuário pode marcar o status `in_progress`.
        
    *   O usuário pode marcar o status `completed`.
        
    *   O usuário pode desmarcar `completed` (voltando para `in_progress`) ou desmarcar `in_progress` (voltando para `assigned`). A lógica deve impedir que se pule de `completed` diretamente para `assigned`.
        

#### REQ-04: Lógica de Propagação de Status (Backend/Cloud Functions)

*   **Descrição:** Define as regras de negócio automáticas que ocorrem em cascata quando um voluntário atualiza seu status. **Esta lógica é crítica e deve, preferencialmente, ser implementada via Cloud Functions ou transações no backend para garantir a consistência dos dados.**
    
*   **Regras de Negócio:**
    
    1.  **Microtarefa para "Em Andamento":** Quando **pelo menos 1** voluntário de uma microtarefa atualiza seu status em `user_microtasks` para `in_progress`, o status do documento principal na collection `microtasks` deve ser automaticamente alterado para `in_progress`.
        
    2.  **Tarefa para "Em Andamento":** Se o status de uma `microtask` muda para `in_progress` (conforme regra anterior), o status de sua `task` pai na collection `tasks` também deve ser alterado para `in_progress`.
        
    3.  **Microtarefa para "Concluída":** Quando **todos** os voluntários listados no campo `assignedTo` da `microtask` tiverem seus respectivos documentos em `user_microtasks` com o status `completed`, o status do documento principal na collection `microtasks` deve ser alterado para `completed`.
        
    4.  **Tarefa para "Concluída":** Quando **todas** as `microtasks` pertencentes a uma `task` estiverem com o status `completed`, o status do documento da `task` pai na collection `tasks` deve ser alterado para `completed`.
        

### 4\. Proposta de Design (Componente da Agenda)

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

### 5\. Análise de Impacto

*   **Firestore:**
    
    *   Será necessário criar queries eficientes para a aba Agenda: `db.collection('user_microtasks').where('userId', '==', currentUser.id).where('eventId', '==', currentEvent.id)`.
        
*   **Código da Aplicação (Arquivos a serem modificados/criados):**
    
    *   `lib/presentation/screens/event/event_details_screen.dart`: Adicionar a nova `Tab` "AGENDA" na `TabBar`.
        
    *   **\[NOVO\]** `lib/presentation/screens/agenda/agenda_screen.dart`: Arquivo que conterá a UI da nova aba, incluindo a lógica para buscar e listar as microtarefas.
        
    *   **\[NOVO\]** `lib/presentation/widgets/agenda/microtask_agenda_card.dart`: O novo componente de card reutilizável.
        
    *   `lib/presentation/controllers/task_controller.dart` (ou um novo `agenda_controller.dart`): Gerenciar o estado da agenda, buscar os dados e lidar com as ações de clique do usuário.
        
    *   `lib/data/services/task_service.dart` ou `microtask_service.dart`: Adicionar um método para o usuário atualizar seu status em `user_microtasks`. Ex: `updateUserMicrotaskStatus(userMicrotaskId, newStatus)`.
        
    *   Os serviços `task_service` e `microtask_service` também podem precisar de métodos para a atualização de status em cascata, caso não seja usado Cloud Functions.
        

### 6\. Critérios de Aceite

| ID | Critério | Verificação |
| --- | --- | --- |
| AC-19 | A aba "AGENDA" está visível na tela de detalhes do evento apenas para voluntários.
| AC-20 | A aba "AGENDA" lista todos (e somente) os cards das microtarefas atribuídas ao usuário logado para aquele evento.
| AC-21 | Cada card na agenda exibe o título da microtarefa, a tarefa pai e o stepper de status horizontal (Atribuída, Em Andamento, Concluída).
| AC-22 | Ao clicar no check "Em Andamento", o status do documento correspondente emuser_microtasksé atualizado parain_progresse o visual do card reflete a mudança.
| AC-23 | Ao clicar no check "Concluída", o status emuser_microtasksé atualizado paracompleted.
| AC-24 | O usuário pode desmarcar um status, voltando para o estado anterior (ex: de Concluída para Em Andamento).
| AC-25 | (Regra 1)Quando o 1º voluntário de uma microtarefa marca "Em Andamento", o status do documento emmicrotasksmuda parain_progress.
| AC-26 | (Regra 2)Quando umamicrotaskfica "Em Andamento", suataskpai também fica "Em Andamento".
| AC-27 | (Regra 3)O status de umamicrotasksó muda paracompleteddepois quetodosos seus voluntários atribuídos marcarem "Concluída".
| AC-28 | (Regra 4)O status de umatasksó muda paracompleteddepois quetodasas suas microtarefas estiverem "Concluídas".

