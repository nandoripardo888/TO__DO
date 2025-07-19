### 1\. Resumo e Objetivo

Este documento detalha os requisitos para modificar a regra de negócio durante a criação de uma campanha e introduzir uma nova funcionalidade para o gerenciamento de dados de voluntário do próprio usuário.

O objetivo é duplo:

1.  **Otimizar o fluxo do Gerenciador:** Ao criar uma campanha, o gerenciador, que frequentemente também atua como voluntário, será automaticamente inscrito como tal, eliminando a necessidade de um passo manual posterior.
    
2.  **Melhorar a Autonomia do Usuário:** Fornecer uma interface clara e acessível para que qualquer voluntário (incluindo o gerenciador) possa visualizar e atualizar suas informações de voluntariado (disponibilidade, habilidades, etc.) a qualquer momento dentro do contexto de uma campanha.
    

### 2\. Justificativa

Atualmente, o fluxo exige que um gerenciador crie a campanha e, em um segundo momento, use o código da campanha para se inscrever como voluntário, um passo redundante. Além disso, não há uma maneira direta para um voluntário já inscrito editar suas informações, como mudar sua disponibilidade.

Essa modificação irá:

*   **Aumentar a eficiência:** Reduz o número de etapas para o gerenciador participar ativamente do seu própria campanha.
    
*   **Melhorar a experiência do usuário (UX):** Oferece um local centralizado e intuitivo para o usuário gerenciar seus próprios dados de voluntariado, dando-lhe mais controle e flexibilidade.
    
*   **Garantir a consistência dos dados:** Facilita a manutenção de perfis de voluntário atualizados, o que beneficia o gerenciamento e a atribuição de tarefas.
    

### 3\. Requisitos Funcionais Detalhados

#### REQ-01: Inscrição Automática do Gerenciador como Voluntário

*   **Descrição:** Ao concluir a criação de um nova campanha na `create_event_screen.dart`, o sistema deve executar duas ações simultaneamente.
    
*   **Regra de Negócio:**
    
    1.  O usuário que criou a campanha (`createdBy`) é adicionado à lista `managers` da collection `events`. (Comportamento atual)
        
    2.  **\[NOVO\]** O mesmo usuário (`createdBy`) deve ser **automaticamente adicionado** à lista `volunteers` na mesma collection `events`.
        
    3.  **\[NOVO\]** Um documento correspondente deve ser criado na collection `volunteer_profiles`. Este perfil inicial pode ter valores padrão (ex: disponibilidade a ser preenchida), mas deve ligar `userId` e `eventId`. O ideal é que o usuário seja levado a preencher esses dados logo após a criação.
        

#### REQ-02: Nova Aba "Perfil" na Tela de Detalhes da campanha

*   **Descrição:** A tela `event_details_screen.dart` deve ser modificada para incluir uma nova aba.
    
*   **Regra de Negócio:**
    
    1.  A estrutura de `Tabs` nesta tela, que atualmente contém "campanha", "Criar Tasks", "Gerenciar Voluntários" e "Acompanhar Tasks", deve ser atualizada.
        
    2.  **\[NOVO\]** Uma nova aba chamada **"Perfil"** (ou "Meu Perfil de Voluntário") deve ser adicionada.
        
    3.  **Visibilidade:** Esta aba deve ser visível para **qualquer usuário que esteja na lista `volunteers` da campanha**, incluindo o gerenciador (conforme REQ-01). Se o usuário não for voluntário, a aba não deve ser exibida.
        

#### REQ-03: Tela de Visualização e Edição de Dados de Voluntário

*   **Descrição:** A nova aba "Perfil" deve exibir uma tela dedicada para o gerenciamento do perfil de voluntário do usuário logado. A melhor abordagem de UX é criar uma tela de visualização que leva para uma tela de edição.
    
*   **Proposta de Fluxo:**
    
    1.  **Tela de Visualização (`view_volunteer_profile_screen.dart` - NOVA):**
        
        *   Ao clicar na aba "Perfil", o usuário vê suas informações atuais de voluntário para aquele campanha.
            
        *   **Conteúdo:** Exibição clara e apenas de leitura dos campos do `volunteer_profiles_model.dart`:
            
            *   Disponibilidade (Dias e Horários)
                
            *   Disponibilidade Integral
                
            *   Habilidades
                
            *   Recursos
                
        *   **Ação:** A tela deve conter um botão ou ícone de "Editar".
            
    2.  **Tela de Edição (Reaproveitamento da `join_event_screen.dart` ou criação de `edit_volunteer_profile_screen.dart`):**
        
        *   Ao clicar em "Editar", o usuário é levado para uma tela de formulário.
            
        *   **Reaproveitamento:** A tela `join_event_screen.dart` pode ser adaptada para um "modo de edição".
            
        *   **Pré-preenchimento:** O formulário deve vir preenchido com os dados atuais do voluntário.
            
        *   **Funcionalidade:** O usuário pode alterar todos os campos (disponibilidade, habilidades, recursos) e salvar.
            
        *   **Ação de Salvar:** Ao salvar, o sistema atualiza o documento correspondente na collection `volunteer_profiles` no Firestore. Após salvar, o usuário deve ser redirecionado de volta para a tela de visualização (passo 1) com os dados atualizados.
            

### 4\. Escopo e Exclusões

*   **DENTRO DO ESCOPO:**
    
    *   Modificação da lógica de criação de campanha para registrar o gerenciador como voluntário.
        
    *   Criação da nova aba "Perfil" na tela de detalhes da campanha.
        
    *   Criação de uma tela para visualizar o perfil de voluntário.
        
    *   Criação ou adaptação de uma tela para editar o perfil de voluntário.
        
*   **FORA DO ESCOPO (Nesta Iteração):**
    
    *   **Impacto nas Microtarefas:** A lógica de como a alteração de disponibilidade ou habilidades de um voluntário afeta as microtarefas para as quais ele já foi atribuído **não será tratada neste momento**. O sistema não irá re-validar ou remover atribuições existentes com base nas edições feitas.
        
    *   Notificações sobre a mudança de perfil.
        
    *   Histórico de alterações do perfil de voluntário.
        

### 5\. Análise de Impacto (Com base nos arquivos fornecidos)

*   **Estrutura de Dados (Firestore):**
    
    *   `events`: O processo de criação de campanhas precisa ser modificado para popular o array `volunteers` com o ID do criador.
        
    *   `volunteer_profiles`: O processo de criação de campanhas precisa acionar a criação de um novo documento nesta collection. A nova funcionalidade de edição irá realizar operações de `UPDATE` neste documento.
        
*   **Código da Aplicação (Arquivos a serem modificados):**
    
    *   `lib/data/services/event_service.dart`: A lógica de criação de campanha (`createEvent`) precisará ser estendida para incluir a inscrição como voluntário.
        
    *   `lib/presentation/controllers/event_controller.dart`: Deverá chamar o método de serviço atualizado e gerenciar o estado da nova aba.
        
    *   `lib/presentation/screens/event/create_event_screen.dart`: O fluxo pós-criação pode ser ajustado para, talvez, incentivar o usuário a completar seu perfil de voluntário.
        
    *   `lib/presentation/screens/event/event_details_screen.dart`: Será necessário adicionar a lógica da nova `Tab` e seu controle de visibilidade.
        
    *   `lib/presentation/screens/event/join_event_screen.dart`: Precisará ser analisado se pode ser adaptado para um modo de edição ou se é melhor criar uma nova tela (`edit_volunteer_profile_screen.dart`) baseada nela.
        
    *   **Novos Arquivos:**
        
        *   `lib/presentation/screens/profile/view_volunteer_profile_screen.dart` (ou similar): Para exibir os dados do voluntário.
            
        *   (Opcional) `lib/presentation/screens/profile/edit_volunteer_profile_screen.dart`: Caso se opte por não reutilizar a tela `join_event_screen`.
            

### 6\. Critérios de Aceite

| ID | Critério | Verificação |
| --- | --- | --- |
| AC-01 | Ao criar um nova campanha, ouserIddo criador está presente tanto no arraymanagersquanto no arrayvolunteersdo documento da campanha no Firestore. | ☐ |
| AC-02 | Ao criar um nova campanha, um documento correspondente é criado na collectionvolunteer_profilescom ouserIdeeventIdcorretos. | ☐ |
| AC-03 | Na tela de Detalhes da campanha, a aba "Perfil" aparece para o gerenciador que acabou de criar a campanha. | ☐ |
| AC-04 | A aba "Perfil" aparece para qualquer outro usuário que tenha se juntado aa campanha como voluntário. | ☐ |
| AC-05 | A aba "Perfil"não aparece para usuários que não são voluntários na campanha. | ☐ |
| AC-06 | Clicar na aba "Perfil" exibe uma tela com as informações atuais de voluntariado do usuário (habilidades, disponibilidade, etc.) em modo de visualização. | ☐ |
| AC-07 | A tela de visualização possui um botão "Editar". | ☐ |
| AC-08 | Clicar em "Editar" leva a um formulário com todos os campos pré-preenchidos com os dados atuais. | ☐ |
| AC-09 | Após modificar os dados e salvar, o documento na collectionvolunteer_profilesdo Firestore é atualizado com sucesso. | ☐ |
| AC-10 | Após salvar a edição, o usuário é redirecionado para a tela de visualização e os novos dados são exibidos corretamente. | ☐ |


-------------------------------------------------------------------------
Resumo da Implementação
✅ REQ-04: FAB de Edição na Tela de Detalhes da campanha
Implementado com sucesso:

✅ AC-11: FAB de edição (ícone lápis) posicionado acima do FAB de "+"
✅ AC-12: FAB de edição visível apenas na aba "campanha"
✅ AC-13: FAB de edição visível apenas para gerenciadores
Código implementado:

Modificado _buildFloatingActionButton() para retornar Column com dois FABs na aba "campanha"
Adicionado método _isEventTabActive() para verificar aba ativa
Adicionado método _navigateToEditEvent() para navegação
✅ REQ-05: Tela de Edição de campanha
Implementado com sucesso:

✅ AC-14: Navegação para tela de edição com campos pré-preenchidos
✅ AC-15: Botões "Cancelar" e "Salvar Alterações" no lugar de "Criar campanha"
Código implementado:

Modificado CreateEventScreen para aceitar EventModel? eventToEdit
Adicionado _isEditMode getter para controlar modo
Implementado _populateFieldsForEdit() para pré-preenchimento
Modificado AppBar para mostrar título correto
Implementado _buildActionButtons() para botões diferentes por modo
Atualizado app_routes.dart para aceitar campanha como argumento
✅ REQ-06: Lógica de Salvamento e Cancelamento
Implementado com sucesso:

✅ AC-16: Botão "Cancelar" retorna sem salvar alterações
✅ AC-17: Botão "Salvar Alterações" atualiza dados no Firestore
✅ AC-18: Após salvar, retorna à tela de detalhes com dados atualizados
Código implementado:

Implementado updateEvent() no EventController
Método updateEvent() já existia no EventRepository e EventService
Implementado _handleUpdateEvent() no CreateEventScreen
Adicionado tratamento de erros e feedback visual
Implementado recarregamento de dados após edição
Arquivos Modificados
Update Task List
2 updated
✅ Implementação Completa da Funcionalidade de Edição de campanhas
A funcionalidade de edição de campanhas foi implementada com sucesso conforme especificado no DOC_ALT_R002.md. Todos os requisitos funcionais (REQ-04, REQ-05, REQ-06) e critérios de aceite (AC-11 a AC-18) foram atendidos.

📋 Arquivos Modificados:
 lib/presentation/screens/event/event_details_screen.dart
Adicionado FAB de edição posicionado acima do FAB existente
Implementado controle de visibilidade baseado na aba ativa e permissões
Adicionado navegação para modo de edição
 lib/presentation/screens/event/create_event_screen.dart
Refatorado para aceitar campanha opcional para edição
Implementado pré-preenchimento de campos
Adicionado botões diferentes para modo de criação vs edição
Implementado lógica de atualização de campanha
 lib/presentation/controllers/event_controller.dart
Implementado método updateEvent() com validações
Adicionado tratamento de erros e atualização de estado
 lib/presentation/routes/app_routes.dart
Modificado para aceitar EventModel opcional como argumento
🎯 Funcionalidades Implementadas:
✅ FAB de Edição: Botão flutuante com ícone de lápis, visível apenas na aba "campanha" para gerenciadores
✅ Modo de Edição: Tela reutilizada com campos pré-preenchidos e botões apropriados
✅ Validações: Mesmas validações da criação aplicadas na edição
✅ Persistência: Dados atualizados salvos no Firestore
✅ Feedback: Mensagens de sucesso/erro e recarregamento automático
✅ Navegação: Fluxo completo de edição com retorno à tela de detalhes