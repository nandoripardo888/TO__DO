### **Adendo ao PRD - Versão 1.1**
### 1\. Resumo e Objetivo

Este adendo especifica os requisitos para implementar a funcionalidade de **edição de dados de uma campanha existente**. O objetivo é permitir que os gerenciadores de campanhas modifiquem informações chave da Campanha (como nome, descrição, localização, etc.) após sua criação, oferecendo maior flexibilidade e capacidade de correção.

### 2\. Justificativa

Atualmente, uma vez que uma campanha é criado, seus dados são imutáveis. Na prática, informações podem mudar (ex: alteração de local) ou erros de digitação podem precisar de correção. Implementar a edição de campanhas é crucial para:

*   **Aumentar a Flexibilidade:** Permite que os gerenciadores adaptem a Campanha a novas circunstâncias.
    
*   **Melhorar a Integridade dos Dados:** Garante que os voluntários sempre tenham acesso às informações mais atualizadas e corretas.
    
*   **Completar o Ciclo de Gerenciamento (CRUD):** Adiciona a funcionalidade de "Update" (Atualizar) ao gerenciamento de campanhas, que já possui "Create" (Criar) e "Read" (Ler).
    

### 3\. Requisitos Funcionais Detalhados

#### REQ-04: Botão Flutuante (FAB) para Edição de campanha

*   **Descrição:** Um novo Botão de Ação Flutuante (Floating Action Button - FAB) deve ser adicionado na tela de detalhes da Campanha.
    
*   **Regras de Negócio:**
    
    1.  **Componente:** Um novo FAB, preferencialmente com um ícone de "editar" (lápis).
        
    2.  **Posicionamento:** Este botão deve ser posicionado verticalmente _acima_ do FAB existente de "+" (usado para adicionar Tasks).
        
    3.  **Visibilidade:** A visibilidade do FAB de edição está condicionada a duas regras:
        
        *   Deve estar visível **apenas** quando a aba **"campanha"** da tela `event_details_screen.dart` estiver selecionada.
            
        *   Deve estar visível **apenas** para usuários que estão na lista `managers` da Campanha.
            

#### REQ-05: Tela de Edição de campanha

*   **Descrição:** A funcionalidade de edição deve reaproveitar a tela de criação de campanha existente, `create_event_screen.dart`, com modificações para operar em "modo de edição".
    
*   **Regras de Negócio:**
    
    1.  **Navegação:** Ao clicar no novo FAB de edição (REQ-04), o usuário deve ser navegado para a tela `create_event_screen.dart` (em modo de edição).
        
    2.  **Pré-preenchimento:** Todos os campos do formulário (Nome da Campanha, Descrição, Localização, Habilidades necessárias, Recursos necessários) devem ser preenchidos com os dados atuais da Campanha que está sendo editado.
        
    3.  **Modificação dos Botões:** A barra de ações no final da tela deve ser diferente do modo de criação:
        
        *   O botão "Criar campanha" deve ser removido ou substituído.
            
        *   Dois novos botões devem ser exibidos, preferencialmente lado a lado:
            
            *   **"Cancelar":** Um botão com estilo secundário (ex: contorno ou texto simples) que descarta as alterações.
                
            *   **"Salvar Alterações":** O botão de ação principal, com o mesmo estilo do botão "Criar campanha" original.
                

#### REQ-06: Lógica de Salvamento e Cancelamento

*   **Descrição:** Define o comportamento dos novos botões na tela de edição.
    
*   **Regras de Negócio:**
    
    1.  **Salvar Alterações:**
        
        *   Ao ser clicado, o sistema deve validar os campos (as mesmas validações da criação).
            
        *   Se os dados forem válidos, as informações do documento da Campanha na collection `events` do Firestore devem ser atualizadas com os novos valores.
            
        *   Após a atualização bem-sucedida, o usuário deve ser redirecionado de volta para a tela `event_details_screen.dart`, onde os dados atualizados devem ser visíveis.
            
    2.  **Cancelar:**
        
        *   Ao ser clicado, o sistema deve descartar quaisquer alterações feitas nos campos.
            
        *   O usuário deve ser redirecionado de volta para a tela `event_details_screen.dart` sem que nenhuma modificação seja salva.
            

### 4\. Análise de Impacto

*   **Estrutura de Dados (Firestore):**
    
    *   `events`: Nenhuma mudança na estrutura do model é necessária, mas a coleção será alvo de operações de `UPDATE`.
        
*   **Código da Aplicação (Arquivos a serem modificados):**
    
    *   `lib/presentation/screens/event/event_details_screen.dart`: Precisará ser modificado para incluir o novo FAB e sua lógica de posicionamento e visibilidade condicional com base na aba selecionada e no papel do usuário (gerenciador).
        
    *   `lib/presentation/screens/event/create_event_screen.dart`: Requer uma refatoração significativa para aceitar um `event_model` opcional como argumento. Se o argumento for fornecido, a tela entra em "modo de edição", pré-populando os campos e renderizando os botões "Cancelar" e "Salvar Alterações".
        
    *   `lib/presentation/controllers/event_controller.dart`: Precisará de um novo método para gerenciar o estado e a lógica de atualização da Campanha, que será chamado pela tela de edição.
        
    *   `lib/data/services/event_service.dart`: Um novo método `updateEvent(EventModel event)` deve ser criado para encapsular a lógica de atualização do documento no Firestore.
        
    *   `lib/data/repositories/event_repository.dart`: Precisará espelhar o novo método do `event_service` para manter a arquitetura limpa.
        

### 5\. Critérios de Aceite

| ID | Critério
| AC-11 | O FAB de edição (ícone de lápis) é exibido acima do FAB de "+" na tela de Detalhes da Campanha.
| AC-12 | O FAB de edição só é visível quando a aba "campanha" está ativa. Ao mudar para outras abas, ele desaparece.
| AC-13 | O FAB de edição só é visível para usuários que são gerenciadores da Campanha. Voluntários comuns não o veem.
| AC-14 | Ao clicar no FAB de edição, o usuário navega para a tela de edição e todos os campos estão preenchidos com os dados atuais da Campanha.
| AC-15 | Na tela de edição, o botão "Criar campanha" não está visível. Em seu lugar, os botões "Cancelar" e "Salvar Alterações" são exibidos.
| AC-16 | Clicar em "Cancelar" na tela de edição retorna o usuário à tela de detalhes sem salvar nenhuma alteração.
| AC-17 | Após editar um ou mais campos e clicar em "Salvar Alterações", os dados da Campanha são atualizados no Firestore.
| AC-18 | Após salvar, o usuário é retornado à tela de detalhes e pode visualizar as informações atualizadas da Campanha.

Funcionalidade de Edição de campanhas - IMPLEMENTADA COM SUCESSO
🔧 Problema Identificado e Resolvido:
O problema era que a rota /create-event estava definida no mapa de rotas estáticas (routes), que não suporta argumentos. Quando o Flutter encontra uma rota no mapa estático, ele usa essa definição em vez de chamar o onGenerateRoute.

Solução: Removi a rota /create-event do mapa estático, forçando o Flutter a usar o onGenerateRoute, que suporta argumentos.

---------------------------------------------------------------------------------------------------
📋 Implementação Completa:
✅ REQ-04: FAB de Edição
FAB de edição com ícone de lápis posicionado acima do FAB de "+"
Visibilidade condicional: apenas na aba "campanha" e apenas para gerenciadores
Navegação correta para modo de edição
✅ REQ-05: Modo de Edição
Tela reutilizada com campos pré-preenchidos
Título dinâmico: "Editar campanha" vs "Criar campanha"
Botões diferentes: "Cancelar" e "Salvar Alterações" lado a lado
✅ REQ-06: Lógica de Salvamento
Método updateEvent() implementado no controller
Validações aplicadas (mesmas da criação)
Persistência no Firestore via service/repository
Feedback visual com mensagens de sucesso/erro
Recarregamento automático dos dados após edição
🎯 Todos os Critérios de Aceite Atendidos:
✅ AC-11: FAB de edição exibido acima do FAB de "+"
✅ AC-12: FAB visível apenas na aba "campanha"
✅ AC-13: FAB visível apenas para gerenciadores
✅ AC-14: Campos pré-preenchidos na tela de edição
✅ AC-15: Botões "Cancelar" e "Salvar Alterações"
✅ AC-16: Botão "Cancelar" retorna sem salvar
✅ AC-17: Dados atualizados no Firestore
✅ AC-18: Retorno à tela de detalhes com dados atualizados
📁 Arquivos Modificados:
event_details_screen.dart: FAB de edição e navegação
create_event_screen.dart: Modo de edição com pré-preenchimento
event_controller.dart: Método updateEvent()
app_routes.dart: Rota dinâmica com suporte a argumentos