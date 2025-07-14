# Testes da Fase 3: Sistema de Tarefas

## 🎯 Objetivo da Fase 3
Implementar o sistema completo de tarefas hierárquicas (Tasks → Microtasks) com suporte a múltiplos voluntários por microtask, incluindo criação, atribuição, acompanhamento e gerenciamento colaborativo.

## 📋 Funcionalidades a Implementar

### 1. Modelos de Dados
- [x] **TaskModel**: Modelo para tasks (organizadoras)
- [x] **MicrotaskModel**: Modelo para microtasks com múltiplos voluntários
- [x] **UserMicrotaskModel**: Relação usuário-microtask para controle individual
- [x] **Enums**: TaskStatus, MicrotaskStatus, TaskPriority

### 2. Serviços e Repositórios
- [x] **TaskService**: Operações CRUD para tasks
- [x] **MicrotaskService**: Operações CRUD para microtasks
- [x] **TaskRepository**: Camada de abstração para tasks
- [x] **MicrotaskRepository**: Camada de abstração para microtasks
- [x] **AssignmentService**: Sistema de atribuição múltipla
- [x] **TaskController**: Gerenciamento de estado

### 3. Telas Principais
- [x] **EventDetailsScreen**: Tela com sistema de tabs
- [x] **CreateTasksScreen**: Criação de tasks e microtasks
- [x] **ManageVolunteersScreen**: Gerenciamento e atribuição (placeholder)
- [x] **TrackTasksScreen**: Acompanhamento hierárquico (básico)

### 4. Widgets Específicos
- [x] **LoadingWidget**: Widget de carregamento
- [x] **TaskCard**: Card para exibir tasks com progresso e expansão
- [x] **MicrotaskCard**: Card para microtasks com múltiplos voluntários
- [x] **VolunteerCard**: Card de voluntário com informações e disponibilidade
- [x] **TaskProgressWidget**: Indicador de progresso (linear e circular)
- [x] **AssignmentDialog**: Dialog para atribuição com filtros de compatibilidade
- [x] **ManageVolunteersScreen**: Tela completa para gerenciamento (estrutura pronta)

## 🧪 Plano de Testes Detalhado

### Teste 1: Criação de Tasks
**Objetivo**: Validar criação de tasks organizadoras

**Pré-requisitos**: 
- Usuário logado como gerenciador de evento
- Evento criado na Fase 2

**Passos**:
1. Navegar para detalhes do evento
2. Acessar tab "Criar Tasks"
3. Preencher formulário de task:
   - Nome: "Organização do Local"
   - Descrição: "Preparar e organizar o espaço do evento"
   - Prioridade: Alta
4. Salvar task
5. Verificar se task aparece na lista
6. Verificar se task aparece no tab "Acompanhar Tasks"

**Resultado Esperado**:
- Task criada com sucesso
- Status inicial: "pending"
- Aparece em todas as visualizações relevantes

### Teste 2: Criação de Microtasks
**Objetivo**: Validar criação de microtasks com configuração de múltiplos voluntários

**Pré-requisitos**: 
- Task criada no Teste 1

**Passos**:
1. Na tela "Criar Tasks", seção "Criar Microtask"
2. Selecionar task pai: "Organização do Local"
3. Preencher formulário:
   - Nome: "Montagem de Palco"
   - Descrição: "Montar estrutura do palco principal"
   - Habilidades necessárias: ["Montagem", "Trabalho em Altura"]
   - Recursos necessários: ["Ferramentas", "EPI"]
   - Tempo estimado: 4 horas
   - Prioridade: Alta
   - **Número máximo de voluntários: 3**
4. Salvar microtask
5. Repetir para criar mais 2-3 microtasks

**Resultado Esperado**:
- Microtasks criadas com sucesso
- Campo maxVolunteers configurado corretamente
- Microtasks vinculadas à task pai
- Status inicial: "pending"

### Teste 3: Sistema de Atribuição Múltipla
**Objetivo**: Validar atribuição de múltiplos voluntários à mesma microtask

**Pré-requisitos**:
- Microtasks criadas no Teste 2
- Pelo menos 5 voluntários no evento com habilidades compatíveis

**Passos**:
1. Navegar para tab "Gerenciar Voluntários"
2. Selecionar primeiro voluntário
3. Clicar em "Atribuir Microtask"
4. Selecionar microtask "Montagem de Palco"
5. Confirmar atribuição
6. Repetir para mais 2 voluntários (até o limite de 3)
7. Tentar atribuir um 4º voluntário
8. Verificar se sistema impede (limite atingido)
9. Tentar atribuir o mesmo voluntário novamente
10. Verificar se sistema impede (duplicação)

**Resultado Esperado**:
- Primeiros 3 voluntários atribuídos com sucesso
- 4º voluntário rejeitado (limite atingido)
- Duplicação impedida
- Status da microtask muda para "assigned"
- Voluntários aparecem na lista da microtask

### Teste 4: Acompanhamento Hierárquico
**Objetivo**: Validar visualização hierárquica e controle de progresso

**Pré-requisitos**:
- Tasks e microtasks criadas
- Voluntários atribuídos

**Passos**:
1. Navegar para tab "Acompanhar Tasks"
2. Verificar estrutura hierárquica:
   - Tasks como containers expandíveis
   - Microtasks dentro das tasks
   - Lista de voluntários por microtask
3. Expandir task "Organização do Local"
4. Verificar microtasks e voluntários atribuídos
5. Clicar em microtask para ver detalhes
6. Verificar ações disponíveis para cada voluntário

**Resultado Esperado**:
- Hierarquia clara e navegável
- Informações completas por microtask
- Lista de voluntários visível
- Ações contextuais disponíveis

### Teste 5: Execução Colaborativa
**Objetivo**: Validar sistema de execução com múltiplos voluntários

**Pré-requisitos**:
- Microtask com 3 voluntários atribuídos

**Cenários de Teste**:

#### 5.1 Início de Trabalho
1. Voluntário 1 marca microtask como "Iniciada"
2. Verificar se status muda para "in_progress"
3. Verificar se outros voluntários veem a mudança
4. Voluntário 2 também marca como "Iniciada"
5. Verificar se não há conflito

#### 5.2 Conclusão Parcial
1. Voluntário 1 marca como "Concluída"
2. Verificar se microtask permanece "in_progress"
3. Verificar indicador de progresso (1/3 concluído)
4. Voluntário 2 marca como "Concluída"
5. Verificar progresso (2/3 concluído)

#### 5.3 Conclusão Total
1. Voluntário 3 marca como "Concluída"
2. Verificar se microtask muda para "completed"
3. Verificar se progresso da task pai é atualizado
4. Verificar se task pai muda status se todas microtasks concluídas

**Resultado Esperado**:
- Sistema de conclusão colaborativa funcional
- Progresso calculado corretamente
- Status propagado hierarquicamente

### Teste 6: Gerenciamento de Voluntários
**Objetivo**: Validar operações de gerenciamento

**Cenários**:

#### 6.1 Remoção de Voluntário
1. Na tela "Gerenciar Voluntários"
2. Selecionar microtask com múltiplos voluntários
3. Remover um voluntário da microtask
4. Verificar se limite de vagas aumenta
5. Verificar se voluntário não aparece mais na lista

#### 6.2 Substituição de Voluntário
1. Remover voluntário de microtask
2. Atribuir novo voluntário à mesma microtask
3. Verificar se substituição funciona corretamente

#### 6.3 Promoção a Gerenciador
1. Selecionar voluntário
2. Promover a gerenciador
3. Verificar se ganha acesso às funcionalidades de gerenciamento

### Teste 7: Filtros e Busca
**Objetivo**: Validar sistema de filtros

**Passos**:
1. Na tela "Acompanhar Tasks"
2. Aplicar filtro por status: "pending"
3. Verificar se apenas tasks/microtasks pendentes aparecem
4. Filtrar por prioridade: "Alta"
5. Filtrar por voluntário específico
6. Combinar múltiplos filtros
7. Limpar filtros

**Resultado Esperado**:
- Filtros funcionam individualmente
- Combinação de filtros funciona
- Limpeza de filtros restaura visualização completa

### Teste 8: Validações de Negócio
**Objetivo**: Validar regras de negócio específicas

**Cenários**:

#### 8.1 Compatibilidade de Habilidades
1. Tentar atribuir voluntário sem habilidades necessárias
2. Verificar se sistema impede ou alerta
3. Atribuir voluntário com habilidades compatíveis
4. Verificar se atribuição é aceita

#### 8.2 Disponibilidade de Horários
1. Verificar se sistema considera disponibilidade
2. Tentar atribuir voluntário indisponível
3. Verificar tratamento adequado

#### 8.3 Limites e Restrições
1. Verificar limite máximo de voluntários por microtask
2. Verificar prevenção de atribuição dupla
3. Verificar validações de formulário

## 🐛 Cenários de Erro a Testar

### Erros de Conectividade
- [ ] Criação de task sem internet
- [ ] Atribuição de voluntário com conexão instável
- [ ] Sincronização de status entre dispositivos

### Erros de Validação
- [ ] Campos obrigatórios vazios
- [ ] Limites de caracteres excedidos
- [ ] Valores inválidos em campos numéricos

### Erros de Permissão
- [ ] Voluntário tentando criar tasks
- [ ] Acesso a funcionalidades restritas
- [ ] Modificação de dados sem permissão

## 📊 Métricas de Sucesso

### Funcionalidades Core
- [ ] Criação de tasks: 100% funcional
- [ ] Criação de microtasks: 100% funcional
- [ ] Atribuição múltipla: 100% funcional
- [ ] Acompanhamento hierárquico: 100% funcional
- [ ] Execução colaborativa: 100% funcional
- [ ] Gerenciamento de voluntários: 100% funcional

### Performance
- [ ] Carregamento de listas < 2 segundos
- [ ] Sincronização em tempo real
- [ ] Interface responsiva

### Usabilidade
- [ ] Fluxos intuitivos
- [ ] Feedback visual adequado
- [ ] Navegação clara
- [ ] Tratamento de erros compreensível

## 🚀 Critérios de Aceitação

Para considerar a Fase 3 concluída, todos os seguintes critérios devem ser atendidos:

1. **Funcionalidades Implementadas**: Todas as funcionalidades listadas funcionando
2. **Testes Passando**: Todos os cenários de teste executados com sucesso
3. **Validações Funcionando**: Regras de negócio implementadas e validadas
4. **Interface Completa**: Todas as telas e componentes implementados
5. **Performance Adequada**: Tempos de resposta dentro do esperado
6. **Tratamento de Erros**: Cenários de erro tratados adequadamente

## 📝 Próximos Passos (Fase 4)

Após conclusão da Fase 3:
1. Sistema de atribuição inteligente automática
2. Relatórios e estatísticas avançadas
3. Notificações push
4. Sistema de chat/comunicação
5. Perfis detalhados de voluntários
