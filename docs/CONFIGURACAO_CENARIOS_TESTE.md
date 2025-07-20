# 🔧 Configuração para Executar o Gerador de Cenários de Teste

Este guia explica passo a passo como configurar e executar o gerador de cenários de teste no projeto ConTask.

## 📋 Pré-requisitos

### 1. Flutter e Dart
- **Flutter SDK** instalado (versão 3.32.5 ou superior)
- **Dart SDK** incluído com o Flutter
- Verificar com: `flutter doctor`

### 2. Dependências do Projeto
Execute no diretório do projeto:
```bash
flutter pub get
```

### 3. Firebase Configurado
O projeto já está configurado com Firebase:
- ✅ **Projeto Firebase**: `contask-52156`
- ✅ **Configurações**: Arquivo `firebase_options.dart` presente
- ✅ **Inicialização**: Configurada no `main.dart`

## 🎯 Pré-requisitos Específicos para Cenários de Teste

### 1. Evento Deve Existir
Antes de executar o gerador, você precisa ter um evento criado no Firestore:

**Opção A: Criar via App ConTask**
1. Execute o app: `flutter run -d chrome`
2. Faça login no sistema
3. Crie um novo evento
4. Anote a **tag do evento** (6 caracteres)

**Opção B: Verificar Eventos Existentes**
1. Acesse o [Firebase Console](https://console.firebase.google.com/)
2. Projeto: `contask-52156`
3. Firestore Database → Coleção `events`
4. Procure por eventos com campo `tag`

### 2. Formato da Tag do Evento
- **Tamanho**: Exatamente 6 caracteres
- **Formato**: Apenas letras maiúsculas (A-Z) e números (0-9)
- **Exemplos**: `ABC123`, `XYZ789`, `TEST01`

## 🚀 Como Executar

### Método 1: Script Interativo (Recomendado)
```bash
dart run_test_scenario.dart
```

### Método 2: Com Parâmetro
```bash
dart run_test_scenario.dart ABC123
```

### Método 3: Script Principal
```bash
dart test_scenarios_generator.dart ABC123
```

### Método 4: Exemplo Sem Firebase (Para Teste)
```bash
dart test_scenarios_example.dart evento-teste
```

## 🔍 Verificação da Configuração

### 1. Teste de Conectividade Firebase
```bash
# Verificar se o projeto compila
dart analyze test_scenarios_generator.dart

# Deve retornar sem erros críticos (apenas warnings sobre print)
```

### 2. Teste com Exemplo Simplificado
```bash
# Executar exemplo sem Firebase
dart test_scenarios_example.dart teste123

# Deve gerar saída com usuários fictícios
```

## 📊 O que o Gerador Faz

1. **Conecta ao Firebase** usando as configurações do projeto
2. **Busca o evento** pela tag fornecida
3. **Cria 10 usuários fictícios** na coleção `users`
4. **Inscreve os usuários** criando perfis na coleção `volunteer_profiles`
5. **Atribui habilidades e recursos** aleatórios de listas predefinidas

## 🛠️ Dados Gerados

### Usuários
- **Nomes**: Combinações realistas brasileiras
- **Emails**: Baseados no nome + número aleatório
- **IDs**: UUIDs únicos
- **Timestamps**: Data/hora atual

### Perfis de Voluntário
- **Habilidades**: 2-6 habilidades da lista padrão
- **Recursos**: 1-4 recursos da lista padrão
- **Disponibilidade**: Dias da semana + horários
- **Dados denormalizados**: Nome e email do usuário

## 🔧 Solução de Problemas

### Erro: "Evento não encontrado"
**Causa**: Evento com a tag especificada não existe
**Solução**:
1. Verificar se a tag está correta
2. Criar o evento via app ou Firebase Console
3. Confirmar que o evento tem o campo `tag`

### Erro: "Permission denied"
**Causa**: Regras de segurança do Firestore
**Solução**:
1. Verificar regras no Firebase Console
2. Para teste, temporariamente permitir leitura/escrita:
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /{document=**} {
      allow read, write: if true; // APENAS PARA TESTE!
    }
  }
}
```

### Erro: "Flutter compilation errors"
**Causa**: Problemas com dependências do Flutter
**Solução**:
1. Executar: `flutter clean && flutter pub get`
2. Usar o exemplo simplificado: `dart test_scenarios_example.dart`

### Erro: "Package not found"
**Causa**: Dependências não instaladas
**Solução**:
```bash
flutter pub get
```

## 📝 Exemplo de Execução Bem-Sucedida

```bash
$ dart run_test_scenario.dart ABC123

🎬 INICIANDO CENÁRIO DE TESTE
==================================================
📅 Data/Hora: 2024-01-15 14:30:00.000
🏷️  Tag do evento: ABC123
==================================================

🚀 Iniciando criação de 10 usuários de teste...
✅ Usuário criado: Ana Silva (ana.silva123@gmail.com)
✅ Usuário criado: Bruno Santos (bruno.santos456@yahoo.com)
...
🎉 Criação de usuários concluída! Total: 10 usuários

🔍 Buscando evento com tag: ABC123
✅ Evento encontrado: Campanha de Arrecadação
🎯 Iniciando inscrição dos usuários no evento...
✅ Ana Silva inscrita com sucesso!
...

🎉 CENÁRIO DE TESTE CONCLUÍDO COM SUCESSO!
```

## 🧹 Limpeza de Dados (Cuidado!)

Para remover os dados de teste:
```dart
final generator = TestScenariosGenerator();
await generator.cleanupTestData();
```

⚠️ **ATENÇÃO**: Remove TODOS os usuários e perfis de teste!

## 📞 Suporte

Em caso de problemas:
1. Verificar logs detalhados
2. Testar com exemplo simplificado
3. Confirmar configuração do Firebase
4. Verificar se o evento existe

---

**Desenvolvido para ConTask - Sistema de Gestão de Campanhas e Voluntários**