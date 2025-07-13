# 📋 Checklist de Desenvolvimento - Task Manager para Eventos

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
- [x] **`/lib/data/` - Models, repositories, services**
- [x] **`/lib/presentation/` - Controllers, screens, widgets, routes**
- [x] **Arquivos de configuração base**

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

## 🏠 FASE 2: Tela Home e Gerenciamento de Eventos

### Tela Home
- [x] **Layout Principal**
  - [x] AppBar com nome e foto do usuário
  - [x] Lista de cards dos eventos
  - [x] FAB com opções "Criar Evento" e "Participar"
- [x] **Event Card**
  - [x] Nome do evento
  - [x] Papel do usuário (Gerenciador/Voluntário)
  - [x] Número de tarefas pendentes
  - [x] Status do evento

### Modelos de Eventos
- [x] `event_model.dart` - Modelo completo do evento
- [x] `volunteer_profile_model.dart` - Perfil do voluntário

### Serviços de Eventos
- [x] `event_service.dart` - CRUD de eventos
- [x] `event_repository.dart` - Camada de dados
- [x] `event_controller.dart` - Gerenciamento de estado

### Criação de Eventos
- [x] **Tela Criar Evento**
  - [x] Formulário completo (nome, descrição, localização)
  - [x] Seleção de habilidades necessárias (chips + adicionar nova)
  - [x] Seleção de recursos necessários (chips + adicionar novo)
  - [x] Geração automática de código/tag único
- [x] Sistema de códigos únicos (validação)
- [x] Validações de formulário

### Participação em Eventos
- [x] **Tela Participar de Evento**
  - [x] Campo para inserir código/tag
  - [x] Busca e exibição do evento
  - [x] Formulário de perfil do voluntário
  - [x] Seleção de disponibilidade (dias/horários)
  - [x] Seleção de habilidades e recursos

---

## 📋 FASE 3: Sistema de Tarefas

### Modelos de Tarefas
- [ ] `task_model.dart` - Modelo da task (organizadora)
- [ ] `microtask_model.dart` - Modelo da microtask com **múltiplos voluntários**
  - [ ] Campo `assignedTo` como array de user_ids
  - [ ] Campo `maxVolunteers` para limite de voluntários
- [ ] `user_microtask_model.dart` - Relação usuário-microtask

### Serviços de Tarefas
- [ ] `task_repository.dart` - CRUD de tasks
- [ ] `microtask_repository.dart` - CRUD de microtasks
- [ ] `task_controller.dart` - Gerenciamento de estado
- [ ] `assignment_service.dart` - Sistema de atribuição múltipla

### Tela Detalhes do Evento
- [ ] **Sistema de Tabs**
  - [ ] Tab "Evento" - Informações gerais + código/tag
  - [ ] Tab "Criar Tasks" (apenas gerenciadores)
  - [ ] Tab "Gerenciar Voluntários" (apenas gerenciadores)
  - [ ] Tab "Acompanhar Tasks"

### Criação de Tasks
- [ ] **Tela Criar Tasks**
  - [ ] Seção criar Task (nome, descrição, prioridade)
  - [ ] Seção criar Microtask
  - [ ] Seleção de task pai
  - [ ] Campos específicos da microtask
  - [ ] **Campo "Número máximo de voluntários"**
  - [ ] Validações e persistência

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
- [ ] `event_card.dart` - Card do evento
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
- [ ] Sistema de status para eventos
- [ ] Sistema de status para tasks (baseado nas microtasks)
- [ ] Sistema de status para microtasks
- [ ] **Cálculo automático de progresso** (Tasks herdam das microtasks)
- [ ] **Conclusão colaborativa** (todos voluntários devem marcar como concluída)

---

## 🧪 Testes e Validação

### Testes Funcionais
- [ ] Teste de autenticação
- [ ] Teste de criação de eventos
- [ ] **Teste de atribuição múltipla de voluntários**
- [ ] **Teste de controle de capacidade máxima**
- [ ] **Teste de conclusão colaborativa**
- [ ] Teste de fluxo completo

### Validações de Negócio
- [ ] Códigos de evento únicos
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
- **Fase 2 - Eventos:** ⏳ 0/15 (0%)
- **Fase 3 - Tarefas:** ⏳ 0/21 (0%) **(+3 itens para múltiplos voluntários)**
- **Componentes:** ⏳ 2/11 (18%) **(+1 componente)**
- **Funcionalidades Avançadas:** ⏳ 0/11 (0%) **(+3 itens para múltiplos voluntários)**
- **Testes:** ⏳ 0/11 (0%) **(+3 testes específicos)**
- **Polimento:** ⏳ 0/10 (0%) **(+2 itens para múltiplos voluntários)**

**PROGRESSO TOTAL: 25/95 tarefas (26.3%)**

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
*CHECKLIST ATUALIZADO para múltiplos voluntários ✅*