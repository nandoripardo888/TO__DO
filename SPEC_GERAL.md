# Especificação do Projeto - Task Manager para Eventos

## 📋 Visão Geral do Projeto

**Plataforma:** Flutter
**Objetivo:** Aplicativo para gerenciamento de tarefas em eventos com sistema de voluntariado
**Banco de Dados:** Firebase Firestore
**Autenticação:** Firebase Auth (Google Sign-In)

## 🎯 Conceito Principal

Sistema onde usuários podem criar eventos, gerenciar tarefas hierárquicas (Tasks → Microtasks) e coordenar voluntários para execução das atividades através de um sistema de tags/códigos únicos.

## 👥 Personas e Fluxos

### Gerenciador de Evento
- Cria eventos com informações detalhadas
- Define habilidades e recursos necessários
- Compartilha código/tag do evento
- Cria e organiza Tasks e Microtasks
- Atribui voluntários às microtasks
- Pode promover voluntários a gerenciadores

### Voluntário
- Ingressa em eventos via código/tag
- Define disponibilidade (dias, horários)
- Especifica habilidades e recursos próprios
- Recebe e executa microtasks atribuídas

## 🔄 Fluxo Principal

1. **Criação de Evento**
   - Usuário cria evento → torna-se gerenciador
   - Sistema gera código/tag único
   - Define: nome, descrição, localização, habilidades necessárias, recursos necessários

2. **Ingresso de Voluntários**
   - Voluntário insere código/tag
   - Preenche perfil: disponibilidade, habilidades, recursos
   - Aguarda atribuição de microtasks

3. **Gestão de Tarefas**
   - Gerenciador cria Tasks (grupos de atividades)
   - Cada Task contém múltiplas Microtasks
   - **Voluntários são atribuídos APENAS às Microtasks** (não às Tasks)
   - **Cada microtask pode ter múltiplos voluntários trabalhando em equipe**
   - Sistema considera compatibilidade: habilidades + disponibilidade + recursos

## 📱 Especificação de Telas

### Design System
- **Cor Principal:** Roxo (#6B46C1)
- **Cor Secundária:** Roxo claro (#A78BFA)
- **Cor de Fundo:** Branco (#FFFFFF)
- **Cor de Texto:** Cinza escuro (#374151)
- **Cor de Sucesso:** Verde (#10B981)
- **Cor de Erro:** Vermelho (#EF4444)
- **Estilo:** Clean, minimalista, Material Design

### 1. Tela de Login
- **Componentes:**
  - Logo centralizado
  - Botão "Entrar com Google" (ícone + texto)
  - Link "Criar conta" na parte inferior
- **Estilo:** Fundo branco, elementos centralizados, botão roxo com bordas arredondadas

### 2. Tela de Cadastro
- **Componentes:**
  - Campos: Nome completo, E-mail, Senha, Confirmar senha
  - Botão "Criar conta"
  - Link "Já tenho conta"
- **Validações:** E-mail válido, senha mínima 6 caracteres, senhas iguais

### 3. Tela Home
- **Layout:**
  - AppBar com nome do usuário e foto
  - Lista de cards dos eventos vinculados
  - FAB (Floating Action Button) com opções:
    - "Criar Evento"
    - "Participar de Evento"
- **Event Card:**
  - Nome do evento
  - Papel do usuário (Gerenciador/Voluntário)
  - Número de tarefas pendentes
  - Status do evento

### 4. Tela Criar Evento
- **Formulário:**
  - Nome do evento (obrigatório)
  - Descrição (texto longo)
  - Localização (campo descritivo)
  - Habilidades necessárias (chips selecionáveis + adicionar nova)
  - Recursos necessários (chips selecionáveis + adicionar novo)
  - Botão "Criar Evento"
- **Pós-criação:** Exibe código/tag gerado

### 5. Tela Participar de Evento
- **Componentes:**
  - Campo para inserir código/tag
  - Botão "Buscar Evento" (alinhado à esquerda com o campo)
  - Exibição dos detalhes do evento encontrado
  - **Verificação de Participação:** Se usuário já é participante, exibe detalhes mas impede nova participação
  - Formulário de perfil do voluntário (apenas se ainda não for participante):
    - Dias disponíveis (checkboxes)
    - Horário disponível (time picker)
    - **Habilidades:** Lista prioritária das habilidades necessárias do evento + opção de adicionar nova
    - **Recursos:** Lista prioritária dos recursos necessários do evento + opção de adicionar novo
    - Botão "Adicionar" para novas habilidades/recursos (alinhado à esquerda)
  - Botão "Confirmar Participação" (apenas se ainda não for participante)

### 6. Tela Detalhes do Evento
- **Tabs de Navegação:**
  - **Evento:** Informações gerais, localização, código/tag
  - **Criar Tasks:** (apenas gerenciadores)
  - **Gerenciar Voluntários:** (apenas gerenciadores)
  - **Acompanhar Tasks:** Visualização de todas as tasks/microtasks

### 7. Tela Criar Tasks
- **Seção Criar Task:**
  - Nome da task
  - Descrição
  - Prioridade (Alta/Média/Baixa)
- **Seção Criar Microtask:**
  - Selecionar task pai
  - Nome da microtask
  - Descrição detalhada
  - Habilidades necessárias
  - Recursos necessários
  - Tempo estimado
  - Prioridade
  - **Número máximo de voluntários** (campo maxVolunteers)

### 8. Tela Gerenciar Voluntários
- **Lista de Voluntários:**
  - Cards com foto, nome, habilidades
  - Indicador de disponibilidade
  - Botão "Atribuir Microtask"
  - Botão "Promover a Gerenciador"
- **Atribuição de Microtasks:**
  - Lista de microtasks disponíveis
  - Filtro por compatibilidade com o voluntário selecionado
  - Visualização dos voluntários já atribuídos à microtask
  - Confirmação de atribuição adicional à microtask
  - Opção de remover voluntários da microtask

### 9. Tela Acompanhar Tasks
- **Visualização Hierárquica:**
  - Tasks expandíveis (containers das microtasks)
  - Microtasks com status visual e **lista de voluntários atribuídos**
  - Filtros: Status, Prioridade, Responsável
  - Indicadores de progresso por Task (baseado nas microtasks concluídas)
- **Detalhes da Microtask:**
  - **Lista de voluntários designados** (pode ser múltiplos)
  - Tempo estimado vs realizado (por voluntário)
  - Status atual da microtask
  - Botões de ação (Iniciar/Concluir/Cancelar) - para cada voluntário atribuído
  - Área de colaboração/notas entre voluntários

## 🗂️ Estrutura de Pastas

```
lib/
├── core/
│   ├── constants/
│   │   ├── app_colors.dart
│   │   ├── app_strings.dart
│   │   ├── app_dimensions.dart
│   │   └── app_constants.dart
│   ├── utils/
│   │   ├── validators.dart
│   │   ├── date_helpers.dart
│   │   ├── string_helpers.dart
│   │   └── permission_helpers.dart
│   ├── theme/
│   │   └── app_theme.dart
│   └── exceptions/
│       └── app_exceptions.dart
├── data/
│   ├── models/
│   │   ├── user/
│   │   │   └── user_model.dart
│   │   ├── event/
│   │   │   └── event_model.dart
│   │   ├── task/
│   │   │   ├── task_model.dart
│   │   │   └── microtask_model.dart
│   │   ├── volunteer/
│   │   │   ├── volunteer_profile_model.dart
│   │   │   └── user_microtask_model.dart
│   │   └── ... (outros models)
│   ├── repositories/
│   │   ├── user/
│   │   │   └── user_repository.dart
│   │   ├── event/
│   │   │   └── event_repository.dart
│   │   ├── task/
│   │   │   ├── task_repository.dart
│   │   │   └── microtask_repository.dart
│   │   ├── volunteer/
│   │   │   └── volunteer_repository.dart
│   │   └── ... (outros repositórios)
│   └── services/
│       ├── auth/
│       │   └── auth_service.dart
│       ├── event/
│       │   └── event_service.dart
│       ├── task/
│       │   ├── task_service.dart
│       │   └── microtask_service.dart
│       ├── volunteer/
│       │   └── assignment_service.dart
│       ├── firebase/
│       │   └── firebase_service.dart
│       ├── storage/
│       │   └── storage_service.dart
│       └── ... (outros services)
├── presentation/
│   ├── controllers/ (usando GetX ou Provider)
│   │   ├── auth_controller.dart
│   │   ├── event_controller.dart
│   │   ├── task_controller.dart
│   │   └── volunteer_controller.dart
│   ├── screens/
│   │   ├── auth/
│   │   │   ├── login_screen.dart
│   │   │   └── register_screen.dart
│   │   ├── home/
│   │   │   └── home_screen.dart
│   │   ├── event/
│   │   │   ├── create_event_screen.dart
│   │   │   ├── join_event_screen.dart
│   │   │   ├── event_details_screen.dart
│   │   │   ├── create_tasks_screen.dart
│   │   │   ├── manage_volunteers_screen.dart
│   │   │   └── track_tasks_screen.dart
│   │   └── profile/
│   │       └── volunteer_profile_screen.dart
│   ├── widgets/
│   │   ├── common/
│   │   │   ├── custom_button.dart
│   │   │   ├── custom_text_field.dart
│   │   │   ├── custom_app_bar.dart
│   │   │   ├── loading_widget.dart
│   │   │   ├── error_widget.dart
│   │   │   └── confirmation_dialog.dart
│   │   ├── event/
│   │   │   ├── event_card.dart
│   │   │   ├── task_card.dart
│   │   │   └── event_info_card.dart
│   │   └── volunteer/
│   │       ├── volunteer_card.dart
│   │       └── skill_chip.dart
│   └── routes/
│       └── app_routes.dart
└── main.dart
```

### Boas práticas para organização de models, repositories e services

- **Separação por domínio:** Crie subpastas para cada domínio (usuário, evento, tarefa, voluntário) dentro de models, repositories e services.
- **Responsabilidade única:** Cada arquivo deve ter apenas uma classe principal.
- **Nada de lógica de UI:** Models, repositórios e services não devem importar nada de Flutter UI.
- **Services:** Responsáveis por interagir diretamente com Firebase, APIs externas, armazenamento, etc.
- **Repositories:** Camada de abstração entre os services e o restante do app. Só chamam services e retornam models.
- **Models:** Representam as entidades do domínio, com métodos de serialização (`fromJson`, `toJson`). Não misturar lógica de negócio ou acesso a dados aqui.

## 🗄️ Estrutura do Banco de Dados (Firestore)

### Collection: users
```json
{
  "id": "user_id",
  "name": "Nome do Usuário",
  "email": "email@exemplo.com",
  "photoUrl": "url_da_foto",
  "createdAt": "timestamp",
  "updatedAt": "timestamp"
}
```

### Collection: events
```json
{
  "id": "event_id",
  "name": "Nome do Evento",
  "description": "Descrição do evento",
  "tag": "ABC123",
  "location": "Endereço descritivo",
  "createdBy": "user_id",
  "managers": ["user_id1", "user_id2"],
  "volunteers": ["user_id3", "user_id4"],
  "requiredSkills": ["skill1", "skill2"],
  "requiredResources": ["resource1", "resource2"],
  "status": "active|completed|cancelled",
  "createdAt": "timestamp",
  "updatedAt": "timestamp"
}
```

### Collection: tasks
```json
{
  "id": "task_id",
  "eventId": "event_id",
  "title": "Título da Tarefa",
  "description": "Descrição da tarefa",
  "priority": "high|medium|low",
  "status": "pending|in_progress|completed",
  "createdBy": "user_id",
  "microtaskCount": 5,
  "completedMicrotasks": 2,
  "createdAt": "timestamp",
  "updatedAt": "timestamp"
}
```

### Collection: microtasks
```json
{
  "id": "microtask_id",
  "taskId": "task_id",
  "eventId": "event_id",
  "title": "Título da Microtarefa",
  "description": "Descrição da microtarefa",
  "assignedTo": ["user_id1", "user_id2", "user_id3"],
  "maxVolunteers": 5,
  "requiredSkills": ["skill1"],
  "requiredResources": ["resource1"],
  "startDateTime": "timestamp", // Data e hora inicial específica (dd/mm/yyyy HH:MM)
  "endDateTime": "timestamp", // Data e hora final específica (dd/mm/yyyy HH:MM)
  "priority": "high|medium|low",
  "status": "pending|assigned|in_progress|completed|cancelled",
  "createdBy": "user_id",
  "assignedAt": "timestamp",
  "startedAt": "timestamp",
  "completedAt": "timestamp",
  "notes": "Observações gerais da microtask",
  "createdAt": "timestamp",
  "updatedAt": "timestamp"
}
```

### Collection: volunteer_profiles
```json
{
  // Dados denormalizados do usuário
  "userName": "Nome do Usuário",
  "userEmail": "email@exemplo.com",
  "userPhotoUrl": "url_da_foto",
  // Dados do perfil
  "assignedMicrotasksCount": 0,
  "id": "volunteer_profile_id",
  "userId": "user_id",
  "eventId": "event_id",
  "availableDays": ["monday", "tuesday", "wednesday"],
  "availableHours": {
    "start": "09:00",
    "end": "18:00"
  },
  "isFullTimeAvailable": false, // Disponibilidade integral (qualquer horário)
  "skills": ["skill1", "skill2"],
  "resources": ["resource1", "resource2"],
  "joinedAt": "timestamp"
}
```
### Collection: user_microtasks
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
  "notes": "Observações do voluntário",
  "createdAt": "timestamp",
  "updatedAt": "timestamp"
}
```

## 🛠️ Stack Tecnológica

### Frontend
- **Flutter** (versão estável mais recente)
- **Dart** (linguagem principal)

### Gerenciamento de Estado
- **Provider** ou **GetX** (a definir)

### Backend & Serviços
- **Firebase Auth** (autenticação)
- **Firebase Firestore** (banco de dados)
- **Firebase Storage** (armazenamento de arquivos)

### Dependências Principais
```yaml
dependencies:
  flutter:
    sdk: flutter
  firebase_core: ^2.15.1
  firebase_auth: ^4.7.3
  cloud_firestore: ^4.8.5
  firebase_storage: ^11.2.6
  google_sign_in: ^6.1.4
  provider: ^6.0.5  # ou get: ^4.6.5
  cached_network_image: ^3.2.3
  intl: ^0.18.1
  uuid: ^3.0.7
```

## 🔧 Funcionalidades Específicas

### Sistema de Atribuição Inteligente
- Compatibilidade automática entre habilidades necessárias e disponíveis
- Verificação de disponibilidade de horários específicos (dd/mm/yyyy HH:MM)
- Suporte a disponibilidade integral (voluntários disponíveis a qualquer momento)
- Sugestão de voluntários mais adequados **para microtasks específicas**
- Tasks servem apenas como agrupadores organizacionais
- **Controle de capacidade máxima por microtask**
- Algoritmo de distribuição equilibrada entre voluntários

### Gerenciamento de Códigos/Tags
- Geração automática de códigos únicos alfanuméricos
- Validação de códigos existentes
- Expiração opcional de códigos

### Sistema de Status
- **Eventos:** active, completed, cancelled
- **Tasks:** pending, in_progress, completed
- **Microtasks:** pending, assigned, in_progress, completed, cancelled

### Sistema de Data/Hora Específica para Microtasks
- **Definição precisa de horários**: Cada microtask possui data/hora inicial e final específicas (formato dd/mm/yyyy HH:MM)
- **Substituição do sistema de horas estimadas**: Ao invés de estimar duração, define-se período exato de execução
- **Validação de períodos**: Sistema impede criação de microtasks com data/hora inicial posterior à final
- **Compatibilidade com disponibilidade**: Verifica se voluntários estão disponíveis no período da microtask

### Sistema de Disponibilidade Integral para Voluntários
- **Opção de disponibilidade total**: Voluntários podem marcar disponibilidade integral (qualquer horário)
- **Flexibilidade máxima**: Voluntários com disponibilidade integral podem ser atribuídos a qualquer microtask
- **Interface simplificada**: Quando marcada disponibilidade integral, campos específicos de dias/horários são ocultados
- **Validação inteligente**: Sistema aceita tanto disponibilidade específica quanto integral

### Sistema de Participação Inteligente
- **Verificação de participação existente** antes de permitir nova inscrição
- **Exibição de status de participação** no resultado da busca
- **Filtragem de habilidades/recursos** baseada nas necessidades do evento
- **Alinhamento de interface** para melhor experiência do usuário

## 🚀 Fases de Desenvolvimento

### ✅ Fase 1: Autenticação e Estrutura Base
- Sistema de login/cadastro
- Configuração Firebase
- Estrutura de pastas
- Tema e componentes básicos

### ✅ Fase 2: Gerenciamento de Eventos
- Criação de eventos
- Sistema de tags/códigos
- Ingresso de voluntários
- **Melhorias de UX:** Alinhamento de botões, verificação de participação, filtros de habilidades

### 🚧 Fase 3: Sistema de Tarefas (EM DESENVOLVIMENTO)
- Criação de tasks e microtasks
- Atribuição manual de voluntários
- Acompanhamento de progresso

### Fase 4: Funcionalidades Avançadas
- Sistema de atribuição inteligente
- Perfis detalhados de voluntários
- Relatórios e estatísticas

## 📝 Considerações Importantes

### Exclusões da Versão 1.0
- Sistema de notificações push
- Testes automatizados
- Chat/mensagens entre usuários
- Sistema de avaliações/feedback

### Regras de Negócio
- Apenas gerenciadores podem criar tasks/microtasks
- Voluntários podem ser promovidos a gerenciadores
- **Voluntários são atribuídos exclusivamente às microtasks** (Tasks são apenas organizadores)
- Microtasks só podem ser atribuídas a voluntários com habilidades compatíveis
- **Cada microtask pode ter múltiplos voluntários** (definido pelo campo maxVolunteers)
- O progresso da Task é calculado automaticamente baseado nas microtasks concluídas
- Eventos podem ter múltiplos gerenciadores
- **Microtask é considerada concluída quando todos os voluntários atribuídos marcam como concluída**

### Validações Principais
- Códigos de evento únicos
- Verificação de permissões por role
- Validação de compatibilidade antes da atribuição de microtasks
- Controle de status das microtasks (Tasks herdam status das microtasks)
- Verificação de disponibilidade do voluntário antes da atribuição
- **Controle de capacidade máxima por microtask**
- **Prevenção de atribuição dupla do mesmo voluntário à mesma microtask**
- Validação de conclusão colaborativa (todos os voluntários devem marcar como concluída)
- **Verificação de participação existente** antes de permitir nova inscrição no evento

### Melhorias de UX Implementadas
- **Alinhamento de botões:** Botões "Buscar" e "Adicionar" alinhados à esquerda com campos de texto
- **Verificação de participação:** Sistema impede participação dupla e informa status atual
- **Filtros inteligentes:** Habilidades/recursos do evento aparecem como opções prioritárias
- **Feedback visual:** Indicadores claros de status de participação

---

**Observação:** Esta especificação serve como base para desenvolvimento. Detalhes de implementação e ajustes podem ser refinados durante o processo de desenvolvimento.