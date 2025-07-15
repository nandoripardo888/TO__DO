# **PRD: Melhorias no Gerenciamento de Voluntários e Atribuição de Tarefas**

Versão: 1.0  
Autor: Gemini  
Data: 14 de Julho de 2025

## **1\. Introdução e Visão Geral**

Este documento descreve os requisitos para aprimorar a tela de "Gerenciar Voluntários" no aplicativo de gerenciamento de eventos. O objetivo é transformar a tela atual em um painel de controle mais robusto, que forneça aos gerentes de eventos informações claras sobre a disponibilidade, carga de trabalho e compatibilidade dos voluntários, otimizando o processo de atribuição de tarefas.

As melhorias propostas incluem a adição de indicadores visuais, filtros avançados e um fluxo de atribuição de tarefas mais intuitivo, alinhado com a lógica de negócio de "Tasks" e "Microtasks" já especificada no projeto.

## **2\. O Problema**

A tela atual de gerenciamento de voluntários é funcional, mas apresenta algumas lacunas:

* **Falta de Informação Visual:** Não há uma indicação clara da carga de trabalho de cada voluntário (quantas tarefas já foram atribuídas).  
* **Filtros Básicos:** Os filtros "Todos", "Disponíveis" e "Com Tarefas" são úteis, mas insuficientes para uma tomada de decisão rápida. Um gerente precisa filtrar por habilidades específicas para encontrar o voluntário certo para uma microtask.  
* **Fluxo de Atribuição Genérico:** O modal atual apresenta as opções "Atribuir Microtask" e "Promover a Gerente" juntas. A atribuição de tarefas é uma ação complexa que merece uma tela dedicada para selecionar a microtask correta com base na compatibilidade.  
* **Disponibilidade Incompleta:** A indicação de "Indisponível hoje" é boa, mas não informa ao gerente *quando* o voluntário estará disponível, dificultando o planejamento.

## **3\. Solução Proposta**

Propomos uma reestruturação da seção de gerenciamento de voluntários, focando em três áreas principais:

1. **Melhorar o Card do Voluntário:** Enriquecer o card com mais informações visuais.  
2. **Criar Filtros Avançados:** Implementar um sistema de filtro por habilidades.  
3. **Desenvolver Telas Dedicadas:** Criar telas específicas para "Atribuir Microtask" e "Promover a Gerente", tornando o fluxo mais claro e funcional.

### **3.1. Mockups e Design das Novas Telas**

#### Tela 1: Gerenciamento de Voluntários (Aprimorada)

**Melhorias no Card do Voluntário:**

* **Indicador de Carga de Trabalho:** Um ícone de "tarefas" (assignment) com um número indicando quantas microtasks estão atribuídas ao voluntário.  
* **Indicador de Compatibilidade:** Um ícone de "estrela" (star) que, ao ser usado com o filtro de habilidades, destacará voluntários compatíveis.  
* **Disponibilidade Detalhada:** Além dos dias da semana, mostrar o horário de disponibilidade (ex: "10h-18h").

**Filtros Avançados:**

* **Filtro por Habilidades:** Um botão "Filtrar por Habilidade" que abre um modal para selecionar uma ou mais habilidades. A lista de voluntários será atualizada para mostrar apenas aqueles que possuem as habilidades selecionadas, destacando-os com o ícone de estrela.

#### Tela 2: Atribuir Microtask (Modal/Nova Tela)

Ao clicar em "Atribuir Microtask" no menu de opções do voluntário, o gerente será levado a uma nova tela.

**Funcionalidades:**

* **Listagem Inteligente:** A lista de microtasks será priorizada para mostrar as mais compatíveis com as habilidades do voluntário selecionado.  
* **Informações da Microtask:** Cada item da lista mostrará:  
  * Nome da Microtask e da Task pai.  
  * Habilidades necessárias (destacando as que o voluntário possui).  
  * Vagas disponíveis (ex: "2 de 3 vagas preenchidas").  
* **Confirmação:** Um botão "Atribuir" que só fica ativo se houver vagas disponíveis.

#### Tela 3: Promover a Gerente (Modal de Confirmação)

Ao clicar em "Promover a Gerente", um modal de confirmação simples e direto será exibido.

**Funcionalidades:**

* **Texto de Confirmação:** Um texto claro perguntando se o gerente tem certeza de que deseja promover o usuário, explicando que a ação concede permissões de gerenciamento.  
* **Ação Irreversível:** Um aviso de que a ação não pode ser desfeita facilmente.  
* **Botões:** "Confirmar Promoção" e "Cancelar".

## **4\. Tarefas Detalhadas para Implementação**

Aqui está a lista de tarefas para um agente de IA ou equipe de desenvolvimento, baseada nos documentos de especificação e checklist.

### Tarefa 1: Atualizar o Modelo de Dados e a Lógica de Negócio

1. **Backend (Firestore):**  
   * No volunteer\_profiles, adicione o campo assignedMicrotasksCount (Number) para armazenar a contagem de tarefas.  
   * Garanta que a coleção events no campo managers (Array) seja atualizada corretamente quando um voluntário for promovido.  
2. **Frontend (Model):**  
   * Atualize o volunteer\_profile\_model.dart para incluir o novo campo assignedMicrotasksCount.

### Tarefa 2: Refatorar a Tela "Gerenciar Voluntários" (manage\_volunteers\_screen.dart)

1. **Atualizar o VolunteerCard (volunteer\_card.dart):**  
   * Adicione um Row para os novos indicadores visuais.  
   * Inclua um Icon(Icons.assignment) junto com um Text para exibir volunteer.assignedMicrotasksCount.  
   * Adicione um Icon(Icons.star) que será controlado por uma variável de estado (ex: isCompatible).  
   * Exiba o horário de disponibilidade (availableHours) do perfil do voluntário.  
2. **Implementar Filtro por Habilidades:**  
   * Adicione um ElevatedButton "Filtrar por Habilidade" na tela.  
   * Ao clicar, exiba um AlertDialog ou showModalBottomSheet que lista todas as requiredSkills do evento.  
   * Permita a seleção de múltiplas habilidades (usando CheckboxListTile).  
   * Armazene as habilidades selecionadas em um StateProvider ou ChangeNotifier.  
   * Filtre a lista de voluntários com base nas habilidades selecionadas. O voluntário deve possuir **todas** as habilidades do filtro para ser exibido.  
   * Quando um filtro de habilidade estiver ativo, ative o ícone de estrela (isCompatible \= true) no VolunteerCard para os voluntários que correspondem ao filtro.  
3. **Refatorar o Menu de Opções:**  
   * No PopupMenuButton (ou similar) do VolunteerCard, mantenha as opções "Atribuir Microtask" e "Promover a Gerente".  
   * Ajuste a navegação para que cada opção chame sua respectiva nova tela/modal.

### Tarefa 3: Criar a Tela "Atribuir Microtask" (assignment\_screen.dart)

1. **Estrutura da Tela:**  
   * Crie uma nova StatefulWidget chamada AssignmentScreen.  
   * Receba o volunteerId e o eventId como parâmetros.  
   * Use um FutureBuilder ou um StreamBuilder para carregar as microtasks do evento que ainda não estão concluídas e que possuem vagas (assignedTo.length \< maxVolunteers).  
2. **Lógica de Compatibilidade e Ordenação:**  
   * Busque o perfil do voluntário (volunteer\_profile\_model) para obter suas habilidades.  
   * Crie uma função que ordene a lista de microtasks:  
     1. Primeiro, as microtasks que requerem habilidades que o voluntário possui.  
     2. Depois, as demais microtasks.  
   * Para cada microtask na lista, calcule as vagas restantes (maxVolunteers \- assignedTo.length).  
3. **Construir o MicrotaskAssignmentCard:**  
   * Crie um widget reutilizável para exibir cada microtask.  
   * O card deve mostrar:  
     * Nome da microtask e da task pai.  
     * Wrap de Chips para as requiredSkills, destacando com uma cor diferente as que o voluntário possui.  
     * Texto "Vagas: X de Y".  
     * Um ElevatedButton "Atribuir".  
   * A lógica do botão "Atribuir" deve:  
     * Estar desabilitado se não houver vagas.  
     * Ao ser clicado, chamar o AssignmentService para adicionar o userId do voluntário ao array assignedTo da microtask.  
     * Exibir um SnackBar de sucesso e fechar a tela (Navigator.pop).  
     * Implementar tratamento de erro (ex: se a vaga for preenchida por outro gerente simultaneamente).

### Tarefa 4: Implementar o Modal "Promover a Gerente"

1. **Criar o ConfirmationDialog (confirmation\_dialog.dart):**  
   * Crie um widget de diálogo genérico que possa ser reutilizado.  
   * Ele deve aceitar title, content (texto descritivo) e uma função onConfirm.  
2. **Lógica da Promoção:**  
   * Na opção "Promover a Gerente", chame showDialog com o ConfirmationDialog.  
   * O texto deve alertar sobre a concessão de permissões.  
   * A função onConfirm deve:  
     1. Chamar um método no EventService ou EventRepository.  
     2. Este método deve adicionar o userId do voluntário ao array managers no documento do evento no Firestore.  
     3. Exibir um SnackBar de sucesso.