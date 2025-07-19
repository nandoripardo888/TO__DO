# Especificação do Projeto - Task Manager para campanhas

## 📋 Visão Geral do Projeto

**Plataforma:** Flutter
**Objetivo:** Aplicativo para gerenciamento de tarefas em campanhas com sistema de voluntariado
**Banco de Dados:** Firebase Firestore
**Autenticação:** Firebase Auth (Google Sign-In)

## 🎯 Conceito Principal

Sistema onde usuários podem criar campanhas, gerenciar tarefas hierárquicas (Tasks → Microtasks) e coordenar voluntários para execução das atividades através de um sistema de tags/códigos únicos.

## 👥 Personas e Fluxos

### Gerenciador de campanha
- Cria campanhas com informações detalhadas
- Define habilidades e recursos necessários
- Compartilha código/tag da Campanha
- Cria e organiza Tasks e Microtasks
- Atribui voluntários às microtasks
- Pode promover voluntários a gerenciadores
- Se torna um voluntario automaticamente
- Pode alterar dados da campanha

### Voluntário
- Ingressa em campanhas via código/tag
- Define disponibilidade (dias, horários)
- Especifica habilidades e recursos próprios
- Recebe e executa microtasks atribuídas
- Acompanha agenda de tarefas

## 🔄 Fluxo Principal

1. **Criação de campanha**
   - Usuário cria campanha → torna-se gerenciador **E voluntário automaticamente**
   - Sistema gera código/tag único
   - Define: nome, descrição, localização, habilidades necessárias, recursos necessários
   - **NOVO:** Criador é automaticamente inscrito como voluntário com perfil padrão

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
  - Lista de cards das campanhas vinculados
  - FAB (Floating Action Button) com opções:
    - "Criar campanha"
    - "Participar de campanha"
- **Event Card:**
  - Nome da Campanha
  - Papel do usuário (Gerenciador/Voluntário)
  - Número de tarefas pendentes
  - Status da Campanha
  - Estatísticas da campanha (novo)

### 4. Tela Criar campanha
- **Formulário:**
  - Nome da Campanha (obrigatório)
  - Descrição (texto longo)
  - Localização (campo descritivo)
  - Habilidades necessárias (chips selecionáveis + adicionar nova)
  - Recursos necessários (chips selecionáveis + adicionar novo)
  - Botão "Criar campanha"
- **Pós-criação:** Exibe código/tag gerado

### 5. Tela Participar de campanha
- **Componentes:**
  - Campo para inserir código/tag
  - Botão "Buscar campanha" (alinhado à esquerda com o campo)
  - Exibição dos detalhes da Campanha encontrado
  - **Verificação de Participação:** Se usuário já é participante, exibe detalhes mas impede nova participação
  - Formulário de perfil do voluntário (apenas se ainda não for participante):
    - Dias disponíveis (checkboxes)
    - Horário disponível (time picker)
    - **Habilidades:** Lista prioritária das habilidades necessárias da Campanha + opção de adicionar nova
    - **Recursos:** Lista prioritária dos recursos necessários da Campanha + opção de adicionar novo
    - Botão "Adicionar" para novas habilidades/recursos (alinhado à esquerda)
  - Botão "Confirmar Participação" (apenas se ainda não for participante)

### 6. Tela Detalhes da Campanha
- **Tabs de Navegação (Dinâmicas):**
  - **campanha:** Informações gerais, localização, código/tag
  - **Voluntários:** (apenas gerenciadores) - Gerenciar voluntários da Campanha
  - **Perfil:** (apenas voluntários) - **NOVA TAB** para gerenciar perfil de voluntário
  - **Acompanhar:** Visualização de todas as tasks/microtasks
  - **Agenda:** (novo) Visualização das microtasks do voluntário

### 7. Tela de Agenda (Nova)
- **Funcionalidades:**
  - Visualização das microtasks atribuídas ao voluntário
  - Organização por data/hora
  - Status visual de cada microtask
  - Stepper de progresso
  - Cards com detalhes da microtask

### 8. Tela de Criação de Tasks
- **Seção Criar Task:**
  - Nome da task
  - Descrição
  - Prioridade (Alta/Média/Baixa)
  - Indicador de progresso

### 9. Tela de Criação de Microtasks
- **Formulário:**
  - Selecionar task pai
  - Nome da microtask
  - Descrição detalhada
  - Habilidades necessárias
  - Recursos necessários
  - Data e hora inicial
  - Data e hora final
  - Prioridade
  - **Número máximo de voluntários** (campo maxVolunteers)

### 10. Tela Gerenciar Voluntários
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

### 11. Tela Acompanhar Tasks
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
│   │   ├── form_validators.dart
│   │   └── error_handler.dart
│   ├── theme/
│   │   └── app_theme.dart
│   └── exceptions/
│       └── app_exceptions.dart
├── data/
│   ├── models/
│   │   ├── user_model.dart
│   │   ├── event_model.dart
│   │   ├── task_model.dart
│   │   ├── microtask_model.dart
│   │   ├── volunteer_profile_model.dart
│   │   └── user_microtask_model.dart
│   ├── repositories/
│   │   ├── auth_repository.dart
│   │   ├── event_repository.dart
│   │   ├── task_repository.dart
│   │   ├── microtask_repository.dart
│   │   ├── user_repository.dart
│   │   └── user_microtask_repository.dart
│   └── services/
│       ├── auth_service.dart
│       ├── event_service.dart
│       ├── task_service.dart
│       ├── microtask_service.dart
│       ├── user_service.dart
│       └── assignment_service.dart
├── presentation/
│   ├── controllers/
│   │   ├── auth_controller.dart
│   │   ├── event_controller.dart
│   │   ├── task_controller.dart
│   │   └── agenda_controller.dart
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
│   │   ├── task/
│   │   │   ├── create_task_screen.dart
│   │   │   └── create_microtask_screen.dart
│   │   ├── agenda/
│   │   │   ├── agenda_screen.dart
│   │   │   └── widgets/
│   │   │       ├── microtask_agenda_card.dart
│   │   │       └── status_stepper.dart
│   │   ├── assignment/
│   │   │   └── assignment_screen.dart
│   │   └── profile/
│   │       └── my_volunteer_profile_screen.dart
│   ├── widgets/
│   │   ├── common/
│   │   │   ├── custom_button.dart
│   │   │   ├── custom_text_field.dart
│   │   │   ├── custom_app_bar.dart
│   │   │   ├── loading_widget.dart
│   │   │   ├── error_widget.dart
│   │   │   ├── error_message_widget.dart
│   │   │   ├── confirmation_dialog.dart
│   │   │   └── skill_chip.dart
│   │   ├── event/
│   │   │   ├── event_card.dart
│   │   │   ├── task_card.dart
│   │   │   ├── event_info_card.dart
│   │   │   ├── event_stats_widget.dart
│   │   │   └── skill_chip.dart
│   │   ├── task/
│   │   │   ├── task_card.dart
│   │   │   ├── microtask_card.dart
│   │   │   └── task_progress_widget.dart
│   │   ├── volunteer/
│   │   │   ├── volunteer_card.dart
│   │   │   └── volunteer_list_widget.dart
│   │   ├── assignment/
│   │   │   ├── volunteer_header.dart
│   │   │   ├── microtask_assignment_card.dart
│   │   │   └── empty_microtasks_widget.dart
│   │   └── dialogs/
│   │       ├── confirmation_dialog.dart
│   │       └── assignment_dialog.dart
│   └── routes/
│       └── app_routes.dart
└── main.dart
```

### Boas práticas para organização de models, repositories e services

- **Separação por domínio:** Crie subpastas para cada domínio (usuário, campanha, tarefa, voluntário) dentro de models, repositories e services.
- **Responsabilidade única:** Cada arquivo deve ter apenas uma classe principal.
- **Nada de lógica de UI:** Models, repositórios e services não devem importar nada de Flutter UI.
- **Services:** Responsáveis por interagir diretamente com Firebase, APIs externas, armazenamento, etc.
- **Repositories:** Camada de abstração entre os services e o restante do app. Só chamam services e retornam models.
- **Models:** Representam as entidades do domínio, com métodos de serialização (`fromJson`, `toJson`). Não misturar lógica de negócio ou acesso a dados aqui.

## 📋 Regras de Negócio e Melhorias Implementadas

### Regras de Negócio Principais

#### RN-01: Registro Automático de Voluntário para Criador de campanha
- **Descrição:** Quando um usuário cria uma campanha, ele é automaticamente registrado como voluntário além de gerenciador
- **Implementação:**
  - Array `volunteers` da Campanha inclui automaticamente o `createdBy`
  - Perfil de voluntário é criado automaticamente com valores padrão
  - Valores padrão: horário 09:00-17:00, disponibilidade não integral, listas vazias para skills/resources
- **Benefício:** Facilita o processo para criadores que também querem participar como voluntários

#### RN-02: Tabs Dinâmicas na Tela de Detalhes da Campanha
- **Descrição:** As tabs são exibidas dinamicamente baseadas nas permissões do usuário
- **Lógica:**
  - Tab "campanha": sempre visível
  - Tab "Voluntários": apenas para gerenciadores
  - Tab "Perfil": apenas para voluntários
  - Tab "Acompanhar": sempre visível
  - Tab "Agenda": sempre visível para voluntários
- **Implementação:** TabController com length dinâmico baseado em permissões

#### RN-03: Gerenciamento de Disponibilidade e Horários
- **Descrição:** Sistema inteligente para gerenciar disponibilidade dos voluntários e horários das microtasks
- **Regras de Disponibilidade:**
  1. **Disponibilidade Padrão:**
     - Ao criar campanha: 09:00-17:00, dias úteis, não integral
     - Ao entrar na campanha: obrigatório definir disponibilidade
  2. **Alterações de Disponibilidade:**
     - Permitida a qualquer momento na aba Perfil
     - Requer validação de conflitos com microtasks já atribuídas
  3. **Disponibilidade Integral:**
     - Sobrepõe configurações específicas de dias/horários
     - Não pode ser desativada se houver microtasks atribuídas fora do horário específico

- **Regras de Horários das Microtasks:**
  1. **Criação de Microtask:**
     - Período mínimo de 30 minutos
     - Não pode iniciar no passado
     - Deve respeitar horário comercial (06:00-22:00)
  2. **Atribuição de Voluntários:**
     - Verificação automática de disponibilidade
     - Bloqueio de atribuições com conflito de horário
     - Sugestão de voluntários disponíveis
  3. **Conflitos e Ajustes:**
     - Notificação de conflitos ao alterar disponibilidade
     - Opção de remover atribuições conflitantes
     - Sistema de waitlist para substituições

#### RN-04: Sistema de Agenda
- **Descrição:** Voluntários podem visualizar e gerenciar suas microtasks atribuídas
- **Funcionalidades:**
  - Visualização de microtasks por data/hora
  - Status visual de progresso
  - Atualização de status da microtask
  - Notificações de novas atribuições
  - Filtros por período (dia, semana, mês)
  - Alertas de conflitos de horário

### Melhorias de UX/UI

#### UI-01: Interface Responsiva
- Cards organizados por seção
- Chips diferenciados para habilidades/recursos
- Feedback visual durante operações
- Navegação intuitiva

#### UI-02: Validações e Feedback
- Validação em tempo real
- Mensagens de erro contextuais
- Confirmação visual de operações
- Estados de loading

### Considerações Técnicas

#### TC-01: Consistência de Dados
- Sincronização entre collections
- Manutenção de integridade referencial
- Tratamento de casos edge

#### TC-02: Performance
- Carregamento otimizado
- Cache local
- Queries eficientes

### Validações Principais

#### Validações de Disponibilidade e Horários
- **Disponibilidade do Voluntário:**
  - Mínimo de 1 dia selecionado quando não integral
  - Horário de início anterior ao horário de fim
  - Horário comercial respeitado (06:00-22:00)
  - Validação de conflitos ao alterar disponibilidade

- **Horários das Microtasks:**
  - Data/hora de início anterior à data/hora de fim
  - Duração mínima de 30 minutos
  - Não permitir início no passado
  - Verificação de conflitos com outras microtasks
  - Respeitar horário comercial (06:00-22:00)

- **Atribuições:**
  - Verificação de disponibilidade do voluntário no período
  - Controle de capacidade máxima por microtask
  - Prevenção de conflitos de horário
  - Bloqueio de atribuições incompatíveis

#### Outras Validações
- Códigos de campanha únicos
- Verificação de permissões por role
- Validação de compatibilidade antes da atribuição de microtasks
- Controle de status das microtasks (Tasks herdam status das microtasks)
- Prevenção de atribuição dupla do mesmo voluntário à mesma microtask
- Validação de conclusão colaborativa (todos os voluntários devem marcar como concluída)
- Verificação de participação existente antes de permitir nova inscrição na Campanha

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
  "name": "Nome da Campanha",
  "description": "Descrição da Campanha",
  "tag": "ABC123",
  "location": "Endereço descritivo",
  "createdBy": "user_id",
  "managers": ["user_id1", "user_id2"],
  "volunteers": ["user_id1", "user_id3", "user_id4"],
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
  "startDateTime": "timestamp",
  "endDateTime": "timestamp",
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
  "userName": "Nome do Usuário",
  "userEmail": "email@exemplo.com",
  "userPhotoUrl": "url_da_foto",
  "assignedMicrotasksCount": 0,
  "id": "volunteer_profile_id",
  "userId": "user_id",
  "eventId": "event_id",
  "availableDays": ["monday", "tuesday", "wednesday"],
  "availableHours": {
    "start": "09:00",
    "end": "18:00"
  },
  "isFullTimeAvailable": false,
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
- **GetX** (definido)

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
  get: ^4.6.5
  cached_network_image: ^3.2.3
  intl: ^0.18.1
  uuid: ^3.0.7
```

## 🔧 Funcionalidades Específicas

### Sistema de Atribuição Inteligente
- Compatibilidade automática entre habilidades necessárias e disponíveis
- Verificação de disponibilidade de horários específicos
- Suporte a disponibilidade integral
- Sugestão de voluntários mais adequados
- Tasks como agrupadores organizacionais
- Controle de capacidade máxima por microtask
- Algoritmo de distribuição equilibrada

### Gerenciamento de Códigos/Tags
- Geração automática de códigos únicos
- Validação de códigos existentes
- Expiração opcional de códigos

### Sistema de Status
- **campanhas:** active, completed, cancelled
- **Tasks:** pending, in_progress, completed
- **Microtasks:** pending, assigned, in_progress, completed, cancelled

### Sistema de Disponibilidade e Horários

#### Disponibilidade dos Voluntários
- **Configuração Inicial:**
  - Durante o cadastro na campanha
  - Pode ser atualizada a qualquer momento na aba Perfil

- **Tipos de Disponibilidade:**
  1. **Disponibilidade Integral (isFullTimeAvailable)**
     - Voluntário disponível em qualquer horário
     - Ignora configurações específicas de dias e horários
     - Ideal para voluntários com agenda flexível

  2. **Disponibilidade Específica**
     - **Dias da Semana (availableDays)**
       - Array com dias disponíveis: ["monday", "tuesday", "wednesday", "thursday", "friday", "saturday", "sunday"]
       - Mínimo de 1 dia selecionado
     - **Horários (availableHours)**
       - Horário de início (start): formato "HH:mm" (24h)
       - Horário de fim (end): formato "HH:mm" (24h)
       - Validação: início deve ser anterior ao fim

#### Definição de Horários das Microtasks
- **Período Específico:**
  - Data e hora de início (startDateTime): timestamp preciso
  - Data e hora de fim (endDateTime): timestamp preciso
  - Formato visual: DD/MM/YYYY HH:mm

- **Validações:**
  - Início deve ser anterior ao fim
  - Duração mínima de 30 minutos
  - Não pode conflitar com outras microtasks do mesmo voluntário

- **Compatibilidade com Voluntários:**
  - Sistema verifica disponibilidade dos voluntários no período
  - Para voluntários com disponibilidade específica:
    1. Verifica se o dia da semana está na lista de availableDays
    2. Verifica se o horário está dentro do intervalo de availableHours
  - Para voluntários com isFullTimeAvailable = true:
    - Automaticamente considerados disponíveis

### Sistema de Agenda
- Visualização de microtasks por data/hora
- Status visual de progresso
- Notificações de novas atribuições
- Atualização de status da microtask
- Filtros por período (dia, semana, mês)
- Visualização de conflitos de horário