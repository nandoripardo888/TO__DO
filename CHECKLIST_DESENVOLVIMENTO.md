# 📋 Checklist de Desenvolvimento - Task Manager para campanhas

## 🎯 Status Geral do Projeto
- **Plataforma:** Flutter
- **Firebase:** ✅ **CONFIGURADO**
- **Progresso Geral:** 5% (1/20 fases principais)

---

## 📦 Configuração Inicial

### ✅ Configuração do Ambiente
- [x] **Firebase configurado** (Auth, Firestore, Storage)
- [x] **Dependências principais instaladas** (Firebase, Provider, utils)
- [x] **Estrutura de pastas criada** (core/, data/, presentation/)
- [x] **Configuração do tema base** (cores, dimensões, tema Material Design)

### 📁 Estrutura de Pastas

- [x] **`/lib/core/` - Constantes, utils, tema, exceções**
- [x] **`/lib/data/` - Separação por domínio:**
    - **`models/`** (user, event, task, volunteer)
    - **`repositories/`** (user, event, task, volunteer)
    - **`services/`** (auth, event, task, volunteer, firebase, storage)
- [x] **`/lib/presentation/` - Controllers, screens, widgets, routes**

### ✅ Boas práticas para models, repositories e services

- [x] Cada model, repositório e service em seu próprio arquivo
- [x] Organização por domínio: facilita encontrar e modificar funcionalidades específicas
- [x] Evite dependências cruzadas entre domínios
- [x] Services só interagem com dados externos (Firebase, APIs)
- [x] Repositories fazem a ponte entre services e o restante do app
- [x] Models não devem conter lógica de negócio, apenas estrutura e serialização

---

## 🎨 Design System & Tema

### Cores e Estilo
- [x] **Definir cores no `app_colors.dart`**
  - [x] **Cor Principal: Roxo (#6B46C1)**
  - [x] **Cor Secundária: Roxo claro (#A78BFA)**
  - [x] **Cores de fundo, texto, sucesso, erro**
- [x] **Configurar tema Material Design**
- [x] **Criar componentes base (botões, campos, etc.)**

---

## 🔐 FASE 1: Autenticação e Estrutura Base

### Modelos de Dados
- [x] **`user_model.dart` - Modelo do usuário**
- [x] **Validações e serialização JSON**

### Serviços de Autenticação
- [x] **`auth_service.dart` - Integração Firebase Auth**
- [x] **`auth_repository.dart` - Camada de dados**
- [x] **`auth_controller.dart` - Gerenciamento de estado**

### Telas de Autenticação
- [x] **Tela de Login**
  - [x] **Layout com logo centralizado**
  - [x] **Botão "Entrar com Google"**
  - [x] **Link "Criar conta"**
- [x] **Tela de Cadastro**
  - [x] **Campos: nome, email, senha, confirmar senha**
  - [x] **Validações (email válido, senha 6+ chars)**
  - [x] **Botão "Criar conta"**

### Navegação Base
- [x] **Configurar rotas (`app_routes.dart`)**
- [x] **Implementar navegação entre telas**
- [x] **Proteção de rotas (usuário logado)**

---

## ✅ FASE 2: Tela Home e Gerenciamento de campanhas

### Tela Home
- [x] **Layout Principal**
  - [x] AppBar com nome e foto do usuário
  - [x] Lista de cards das campanhas
  - [x] FAB com opções "Criar campanha" e "Participar"
- [x] **Event Card**
  - [x] Nome da Campanha
  - [x] Papel do usuário (Gerenciador/Voluntário)
  - [x] Número de tarefas pendentes
  - [x] Status da Campanha

### Modelos de campanhas
- [x] `event_model.dart` - Modelo completo da Campanha
- [x] `volunteer_profile_model.dart` - Perfil do voluntário

### Serviços de campanhas
- [x] `event_service.dart` - CRUD de campanhas
- [x] `event_repository.dart` - Camada de dados
- [x] `event_controller.dart` - Gerenciamento de estado

### Criação de campanhas
- [x] **Tela Criar campanha**
  - [x] Formulário completo (nome, descrição, localização)
  - [x] Seleção de habilidades necessárias (chips + adicionar nova)
  - [x] Seleção de recursos necessários (chips + adicionar novo)
  - [x] Geração automática de código/tag único
- [x] Sistema de códigos únicos (validação)
- [x] Validações de formulário

### Participação em campanhas
- [x] **Tela Participar de campanha**
  - [x] Campo para inserir código/tag
  - [x] Busca e exibição da Campanha
  - [x] Formulário de perfil do voluntário
  - [x] Seleção de disponibilidade (dias/horários)
  - [x] Seleção de habilidades e recursos

### Melhorias de UX Implementadas
- [x] **Alinhamento de botões**: Botões "Buscar" e "Adicionar" alinhados à esquerda
- [x] **Verificação de participação**: Sistema impede participação dupla
- [x] **Filtros inteligentes**: Habilidades/recursos da Campanha como opções prioritárias
- [x] **Feedback visual**: Indicadores claros de status de participação

---

## 📋 FASE 3: Sistema de Tarefas

### Modelos de Tarefas
- [x] `task_model.dart` - Modelo da task (organizadora)
- [x] `microtask_model.dart` - Modelo da microtask com **múltiplos voluntários**
  - [x] Campo `assignedTo` como array de user_ids
  - [x] Campo `maxVolunteers` para limite de voluntários
- [x] `user_microtask_model.dart` - Relação usuário-microtask

### Serviços de Tarefas
- [x] `task_service.dart` - CRUD de tasks no Firebase
- [x] `microtask_service.dart` - CRUD de microtasks no Firebase
- [x] `assignment_service.dart` - Sistema de atribuição múltipla
- [x] `task_repository.dart` - CRUD de tasks
- [x] `microtask_repository.dart` - CRUD de microtasks
- [x] `task_controller.dart` - Gerenciamento de estado

### Tela Detalhes da Campanha
- [x] **Sistema de Tabs**
  - [x] Tab "campanha" - Informações gerais + código/tag
  - [x] Tab "Criar Tasks" (apenas gerenciadores)
  - [x] Tab "Gerenciar Voluntários" (apenas gerenciadores) - placeholder
  - [x] Tab "Acompanhar Tasks" - implementação básica

### Criação de Tasks
- [x] **Tela Criar Tasks**
  - [x] Seção criar Task (nome, descrição, prioridade)
  - [x] Seção criar Microtask
  - [x] Seleção de task pai
  - [x] Campos específicos da microtask
  - [x] **Campo "Número máximo de voluntários"**
  - [x] Validações e persistência

### Gerenciamento de Voluntários
- [ ] **Tela Gerenciar Voluntários**
  - [ ] Lista de voluntários com cards
  - [ ] Indicadores de disponibilidade
  - [ ] Sistema de atribuição de microtasks
  - [ ] **Visualização dos voluntários já atribuídos à microtask**
  - [ ] **Opção de adicionar mais voluntários até o limite**
  - [ ] **Opção de remover voluntários da microtask**
  - [ ] Filtro por compatibilidade
  - [ ] Promoção a gerenciador

### Acompanhamento de Tasks
- [ ] **Tela Acompanhar Tasks**
  - [ ] Visualização hierárquica (Tasks → Microtasks)
  - [ ] **Lista de voluntários designados por microtask**
  - [ ] Status visual e progresso
  - [ ] Filtros (status, prioridade, responsável)
  - [ ] **Ações para cada voluntário atribuído** (Iniciar/Concluir/Cancelar)
  - [ ] **Área de colaboração/notas entre voluntários**

---

## 🧩 Componentes e Widgets

### Widgets Comuns
- [x] **`custom_button.dart` - Botão personalizado**
- [x] **`custom_text_field.dart` - Campo de texto**
- [ ] `custom_app_bar.dart` - AppBar personalizada
- [ ] `loading_widget.dart` - Indicador de carregamento
- [ ] `error_widget.dart` - Widget de erro
- [ ] `confirmation_dialog.dart` - Dialog de confirmação

### Widgets Específicos
- [ ] `event_card.dart` - Card da Campanha
- [ ] `task_card.dart` - Card da task
- [ ] `volunteer_card.dart` - Card do voluntário
- [ ] `skill_chip.dart` - Chip de habilidade
- [ ] `volunteer_list_widget.dart` - Lista de voluntários por microtask

---

## 🔧 Funcionalidades Avançadas

### Sistema de Atribuição Inteligente
- [ ] Algoritmo de compatibilidade de habilidades
- [ ] Verificação de disponibilidade de horários
- [ ] Sugestão automática de voluntários para microtasks
- [ ] **Controle de capacidade máxima por microtask**
- [ ] **Prevenção de atribuição dupla do mesmo voluntário**
- [ ] Validações de atribuição múltipla

### Gerenciamento de Status
- [ ] Sistema de status para campanhas
- [ ] Sistema de status para tasks (baseado nas microtasks)
- [ ] Sistema de status para microtasks
- [ ] **Cálculo automático de progresso** (Tasks herdam das microtasks)
- [ ] **Conclusão colaborativa** (todos voluntários devem marcar como concluída)

---

## 🧪 Testes e Validação

### Testes Funcionais
- [ ] Teste de autenticação
- [ ] Teste de criação de campanhas
- [ ] **Teste de atribuição múltipla de voluntários**
- [ ] **Teste de controle de capacidade máxima**
- [ ] **Teste de conclusão colaborativa**
- [ ] Teste de fluxo completo

### Validações de Negócio
- [ ] Códigos de campanha únicos
- [ ] Verificação de permissões por role
- [ ] **Validação de compatibilidade antes da atribuição**
- [ ] **Controle de status das microtasks**
- [ ] **Verificação de disponibilidade antes da atribuição**
- [ ] **Prevenção de atribuição múltipla do mesmo voluntário**
- [ ] **Validação de conclusão colaborativa**

---

## 📱 Polimento e Finalização

### UX/UI
- [ ] Revisão de design em todas as telas
- [ ] Animações e transições
- [ ] Feedback visual para ações
- [ ] Tratamento de estados de erro
- [ ] **Interface para visualização de múltiplos voluntários**

### Performance
- [ ] Otimização de consultas Firestore
- [ ] Cache de dados
- [ ] Lazy loading de listas
- [ ] Otimização de imagens
- [ ] **Otimização de queries para múltiplos voluntários**

---

## 📊 Métricas de Progresso

- **Configuração:** ✅ 4/4 (100%)
- **Fase 1 - Autenticação:** ✅ 12/12 (100%)
- **Fase 2 - campanhas:** ✅ 19/19 (100%) **(CONCLUÍDA)**
- **Fase 3 - Tarefas:** 🚧 14/21 (66.7%) **(EM DESENVOLVIMENTO)**
- **Componentes:** ⏳ 2/11 (18%) **(+1 componente)**
- **Funcionalidades Avançadas:** ⏳ 0/11 (0%) **(+3 itens para múltiplos voluntários)**
- **Testes:** ⏳ 0/11 (0%) **(+3 testes específicos)**
- **Polimento:** ⏳ 0/10 (0%) **(+2 itens para múltiplos voluntários)**

**PROGRESSO TOTAL: 51/99 tarefas (51.5%)**

---

## 🎯 Regras de Negócio Específicas

### Múltiplos Voluntários por Microtask
- **Voluntários são atribuídos APENAS às microtasks** (não às Tasks)
- **Cada microtask pode ter múltiplos voluntários** (definido por maxVolunteers)
- **Tasks servem apenas como agrupadores organizacionais**
- **Controle de capacidade máxima por microtask**
- **Prevenção de atribuição dupla do mesmo voluntário à mesma microtask**
- **Microtask é considerada concluída quando todos os voluntários atribuídos marcam como concluída**

### Hierarquia e Status
- **Tasks herdam status das microtasks**
- **Progresso da Task calculado automaticamente baseado nas microtasks concluídas**
- **Sistema de conclusão colaborativa obrigatório**

---

*Última atualização: 13/07/2025*
*Firebase configurado ✅*
*Dependências instaladas ✅*
*Estrutura de pastas criada ✅*
*Design System configurado ✅*
*Erros corrigidos e código validado ✅*
*FASE 1 - Autenticação CONCLUÍDA ✅*
*FASE 2 - Gerenciamento de campanhas CONCLUÍDA ✅*
*CHECKLIST ATUALIZADO para múltiplos voluntários ✅*
*TESTE_FASE3.md criado - Iniciando Fase 3 ✅*
*FASE 3 - Modelos, Serviços, Repositórios e Controllers CONCLUÍDOS ✅*
*FASE 3 - Telas básicas implementadas (EventDetailsScreen, CreateTasksScreen) ✅*