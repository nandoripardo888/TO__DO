# 🎯 Gerador de Cenários de Teste - ConTask

Este documento explica como usar o gerador de cenários de teste para criar usuários fictícios e inscrevê-los em eventos com habilidades aleatórias.

## 📋 O que o gerador faz

1. **Cria 10 usuários fictícios** usando `UserService` e `UserModel` com:
   - Nomes e emails realistas
   - Timestamps de criação
   - IDs únicos gerados automaticamente
   - Dados seguindo o modelo real do projeto

2. **Busca eventos** usando `EventModel` e consulta direta ao Firestore

3. **Inscreve os usuários em um evento específico** usando `EventService` e modelos reais:
   - Utiliza `VolunteerProfileModel` para criar perfis
   - Habilidades aleatórias selecionadas da lista padrão
   - Recursos aleatórios disponíveis
   - Horários de disponibilidade variados
   - Alguns usuários com disponibilidade integral (20% de chance)

4. **Integra com Firebase/Firestore** através dos services oficiais do projeto

5. **Sistema de limpeza inteligente** que remove apenas os dados criados na sessão atual

## 🚀 Como usar

### Método 1: Script Interativo (Recomendado)

```bash
dart run_test_scenario.dart
```

O script irá solicitar a tag do evento interativamente.

### Método 2: Com Parâmetro

```bash
dart run_test_scenario.dart ABC123
```

Substitua `ABC123` pela tag do evento desejado.

### Método 3: Script Principal

```bash
dart test_scenarios_generator.dart ABC123
```

## 📝 Pré-requisitos

1. **Evento deve existir**: O evento com a tag especificada deve estar criado no Firestore
2. **Firebase configurado**: O projeto deve estar conectado ao Firebase
3. **Dependências instaladas**: Execute `flutter pub get` antes de usar

## 🏷️ Formato da Tag

- **Tamanho**: Exatamente 6 caracteres
- **Formato**: Apenas letras maiúsculas (A-Z) e números (0-9)
- **Exemplos válidos**: `ABC123`, `XYZ789`, `TEST01`
- **Exemplos inválidos**: `abc123` (minúsculas), `AB12` (muito curto), `ABCDEF` (sem números)

## 📊 Dados Gerados

### Usuários Fictícios
- **Nomes**: Combinações realistas de nomes e sobrenomes brasileiros
- **Emails**: Gerados automaticamente baseados no nome + número aleatório
- **Domínios**: gmail.com, yahoo.com, hotmail.com, outlook.com

### Perfis de Voluntário
- **Habilidades**: 2-6 habilidades aleatórias da lista padrão
- **Recursos**: 1-4 recursos aleatórios da lista padrão
- **Disponibilidade**: 
  - 80% dos usuários: dias específicos da semana + horário definido
  - 20% dos usuários: disponibilidade integral (qualquer horário)

## 🛠️ Habilidades Padrão Disponíveis

- Organização
- Comunicação
- Liderança
- Trabalho em equipe
- Criatividade
- Resolução de problemas
- Gestão de tempo
- Tecnologia
- Design
- Marketing
- E mais...

## 🔧 Recursos Padrão Disponíveis

- Veículo próprio
- Notebook/Computador
- Smartphone
- Câmera fotográfica
- Equipamento de som
- Material de escritório
- Ferramentas básicas
- E mais...

## 📈 Exemplo de Saída

```
🎬 INICIANDO CENÁRIO DE TESTE
==================================================
📅 Data/Hora: 2024-01-15 14:30:00.000
🏷️  Tag do evento: ABC123
==================================================

👥 Criando 10 usuários de teste usando UserService...
✅ Usuário criado: Ana Silva (ana.silva123@gmail.com) - ID: user_abc123
✅ Usuário criado: Bruno Santos (bruno.santos456@yahoo.com) - ID: user_def456
✅ Usuário criado: Maria Oliveira (maria.oliveira789@hotmail.com) - ID: user_ghi789
... (mais 7 usuários)

------------------------------

🔍 Buscando evento com tag: ABC123 usando EventModel...
✅ Evento encontrado: Campanha de Arrecadação

📝 Inscrevendo usuários no evento usando EventService...
✅ Ana Silva inscrita com sucesso!
   📋 Habilidades: Organização, Comunicação, Liderança
   🛠️  Recursos: Veículo próprio, Smartphone
   ⏰ Disponibilidade: monday, wednesday, friday (08:00 - 17:00)

✅ Bruno Santos inscrito com sucesso!
   📋 Habilidades: Marketing, Design, Tecnologia
   🛠️  Recursos: Notebook, Câmera
   ⏰ Disponibilidade: Integral (qualquer horário)

... (mais 8 inscrições)

==================================================
🎉 CENÁRIO DE TESTE CONCLUÍDO COM SUCESSO!
📊 Resumo:
   👥 Usuários criados: 10
   🎯 Evento: Campanha de Arrecadação
   🏷️  Tag: ABC123
==================================================
```

## 🧹 Limpeza de Dados

O gerador inclui um sistema inteligente de limpeza que remove apenas os dados criados na sessão atual:

```dart
final generator = TestScenariosGenerator();
await generator.cleanupTestData();
```

✅ **SEGURO**: Remove apenas os usuários criados pelo gerador na execução atual
⚠️ **NOTA**: Os IDs dos usuários criados são rastreados automaticamente

## 🔍 Verificação dos Dados

Após executar o gerador, você pode verificar os dados criados:

1. **Firebase Console**: Acesse as coleções `users` e `volunteer_profiles`
2. **App ConTask**: Os usuários aparecerão na lista de voluntários do evento
3. **Logs**: O gerador exibe informações detalhadas durante a execução

## 🐛 Solução de Problemas

### Erro: "Evento não encontrado"
- Verifique se o evento com a tag especificada existe no Firestore
- Confirme se a tag está no formato correto (6 caracteres, maiúsculas e números)

### Erro: "Permissão negada"
- Verifique as regras de segurança do Firestore
- Confirme se o usuário está autenticado (se necessário)

### Erro: "Usuário já está inscrito"
- O gerador pula usuários que já estão inscritos no evento
- Isso é normal e não indica erro

## 📞 Suporte

Em caso de problemas:
1. Verifique os logs detalhados do gerador
2. Confirme a configuração do Firebase
3. Teste com um evento simples primeiro

---

**Desenvolvido para o projeto ConTask - Sistema de Gestão de Campanhas e Voluntários**