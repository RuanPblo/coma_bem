# Guia Prático: Laboratório de Análise e Documentação de Bugs em Testes de Regressão

## 1. Introdução

Este laboratório tem como objetivo apresentar, de forma prática, o conceito de **Teste de Regressão**, utilizando o projeto `coma_bem` desenvolvido em Flutter.

O teste de regressão é utilizado para verificar se uma alteração realizada no sistema acabou prejudicando uma funcionalidade que anteriormente funcionava corretamente.

Durante a atividade, será criado propositalmente um erro no aplicativo. Em seguida, o teste automatizado será executado para identificar a falha. Após isso, o erro será analisado, documentado e corrigido.

O processo realizado será:

**Alteração → Execução do teste → Detecção do bug → Análise → Documentação → Correção → Novo teste**

> **Importante:** não será criado um novo projeto. Toda a atividade será realizada no projeto existente `coma_bem`.

---

# 2. Objetivos

Ao realizar este laboratório, espera-se compreender:

* O conceito de teste de regressão;
* Como testes automatizados detectam alterações inesperadas;
* Como interpretar mensagens de erro no terminal;
* Como identificar a causa de um bug;
* Como documentar um bug de forma profissional;
* Como corrigir o problema encontrado;
* Como executar novamente os testes após uma correção.

---

# 3. Ambiente Utilizado

Para realizar a atividade, serão utilizados:

* Visual Studio Code;
* Flutter;
* Projeto `coma_bem`;
* Emulador Android ou dispositivo físico;
* Terminal do VS Code;
* Teste de integração localizado em:

```text
integration_test/app_test.dart
```

A tela utilizada para criar o bug está localizada em:

```text
lib/screens/login_screen.dart
```

---

# 4. Passo 1 — Criação do Bug

Para simular uma alteração realizada incorretamente por um desenvolvedor, será modificado o texto do botão de login.

## 4.1 Localizando o arquivo

No Visual Studio Code:

1. Abra o projeto `coma_bem`.
2. No explorador de arquivos, abra a pasta `lib`.
3. Entre na pasta `screens`.
4. Abra o arquivo:

```text
login_screen.dart
```

## 4.2 Alterando o botão

Localize o botão que possui o texto:

```dart
Text('Entrar')
```

Altere para:

```dart
Text('Acessar')
```

Depois, salve o arquivo utilizando:

**Ctrl + S**

### O que aconteceu?

O aplicativo agora apresenta o botão com o texto **"Acessar"**, enquanto o teste automatizado ainda está procurando pelo texto **"Entrar"**.

Essa alteração representa uma possível regressão causada por uma modificação no sistema.

---

# 5. Passo 2 — Execução do Teste de Regressão

Depois de criar o bug, será executado o teste automatizado.

## 5.1 Abrindo o terminal

No VS Code:

**Terminal → New Terminal**

Também é possível utilizar o terminal integrado localizado na parte inferior da tela.

## 5.2 Executando o teste

Digite:

```bash
flutter test integration_test/app_test.dart
```

Pressione **Enter**.

O teste irá abrir o aplicativo e tentar executar automaticamente o fluxo de login.

---

# 6. Resultado do Teste

Durante a execução, o robô realizará as ações programadas, como:

1. Abrir o aplicativo;
2. Preencher o e-mail;
3. Preencher a senha;
4. Procurar o botão de login;
5. Tentar clicar no botão;
6. Verificar se o login foi realizado.

Porém, o teste foi programado para procurar pelo texto:

```text
Entrar
```

Como o botão foi alterado para:

```text
Acessar
```

o teste não consegue localizar o elemento.

Como consequência, o teste apresenta uma falha e pode terminar com uma mensagem semelhante a:

```text
Some tests failed.
```

---

# 7. Passo 3 — Análise do Erro

Um profissional de Qualidade de Software não deve apenas informar que o teste falhou. É necessário analisar o erro para descobrir sua causa.

No terminal do VS Code, procure a mensagem relacionada ao elemento que não foi encontrado.

Um erro esperado pode ser semelhante a:

```text
Expected: exactly one matching node in the widget tree
Actual: _TextFinder:<zero widgets with text "Entrar">
```

## 7.1 Interpretando a mensagem

A mensagem indica que:

* **Expected:** o teste esperava encontrar exatamente um elemento;
* **Actual:** nenhum elemento foi encontrado;
* **"Entrar":** era o texto que o teste estava procurando.

Em outras palavras:

> O teste procurou pelo botão ou texto "Entrar", mas não encontrou nenhum elemento com esse conteúdo na tela.

---

# 8. Identificação da Causa do Bug

Após analisar o erro, é possível comparar o teste com a interface do aplicativo.

O teste procura:

```dart
find.text('Entrar');
```

Enquanto a interface foi alterada para:

```dart
Text('Acessar')
```

Portanto, existe uma diferença entre aquilo que o teste procura e aquilo que está presente na aplicação.

### Causa identificada

O texto do botão de login foi alterado de **"Entrar"** para **"Acessar"**, fazendo com que o teste automatizado não encontrasse mais o elemento esperado.

Isso demonstra a importância dos testes de regressão: uma alteração aparentemente simples na interface pode fazer um teste existente falhar.

---

# 9. Passo 4 — Documentação do Bug

Depois de identificar o problema, é necessário registrar as informações de maneira organizada.

Na raiz do projeto `coma_bem`, crie um novo arquivo:

```text
BUG_001_LOGIN.md
```

A extensão `.md` significa **Markdown** e permite criar documentos organizados que também podem ser visualizados facilmente no GitHub.

---

# 10. Relatório de Bug

## BUG #001 — Falha no Fluxo de Login

**ID do Bug:** #001
**Severidade:** Alta
**Funcionalidade:** Tela de Login
**Arquivo relacionado:** `lib/screens/login_screen.dart`
**Tipo:** Falha em teste de regressão

### 10.1 Descrição do Problema

O teste automatizado de integração falhou durante a execução do fluxo de login.

Após o preenchimento do e-mail e da senha, o teste não conseguiu localizar o botão utilizado para continuar o processo de login.

### 10.2 Passos para Reproduzir

1. Abrir o aplicativo `coma_bem`.
2. Acessar a tela de login.
3. Informar um e-mail válido.
4. Informar uma senha válida.
5. Executar o teste de integração:

```bash
flutter test integration_test/app_test.dart
```

6. Aguardar a execução do teste.

### 10.3 Resultado Esperado

O teste deveria localizar o botão com o texto:

```text
Entrar
```

Depois, deveria clicar no botão e continuar o fluxo de login, realizando a navegação para a próxima tela do aplicativo.

### 10.4 Resultado Atual

O teste não consegue localizar o texto **"Entrar"** e termina com uma falha/timeout.

A mensagem encontrada no terminal indica:

```text
zero widgets with text "Entrar"
```

### 10.5 Causa Raiz

A causa do problema foi a alteração do texto do botão de login.

Anteriormente:

```dart
Text('Entrar')
```

Após a alteração:

```dart
Text('Acessar')
```

O teste automatizado continuou procurando pelo texto antigo:

```dart
find.text('Entrar')
```

Por isso, o elemento não foi encontrado.

---

# 11. Passo 5 — Correção do Bug

Após documentar o problema, é necessário realizar uma correção e executar novamente o teste.

Existem duas possibilidades.

## Opção A — Voltar o botão para "Entrar"

No arquivo:

```text
lib/screens/login_screen.dart
```

Altere:

```dart
Text('Acessar')
```

para:

```dart
Text('Entrar')
```

Salve o arquivo.

---

## Opção B — Atualizar o teste

Caso a alteração para "Acessar" seja realmente desejada na interface, o teste deverá ser atualizado.

Abra:

```text
integration_test/app_test.dart
```

Localize:

```dart
final botaoEntrar = find.text('Entrar');
```

Altere para:

```dart
final botaoEntrar = find.text('Acessar');
```

Salve o arquivo.

---

# 12. Executando o Teste Novamente

Depois de realizar a correção, execute novamente:

```bash
flutter test integration_test/app_test.dart
```

O objetivo é verificar se o problema foi solucionado.

Quando todos os testes forem executados corretamente, o terminal deverá apresentar uma mensagem indicando sucesso, como:

```text
All tests passed!
```

---

# 13. Ciclo Completo de Qualidade de Software

Nesta atividade, foi realizado um ciclo completo de identificação e correção de um problema:

```text
┌─────────────────────────┐
│  Alteração no sistema   │
└────────────┬────────────┘
             ↓
┌─────────────────────────┐
│ Execução do teste       │
└────────────┬────────────┘
             ↓
┌─────────────────────────┐
│ Detecção da regressão   │
└────────────┬────────────┘
             ↓
┌─────────────────────────┐
│ Análise do erro         │
└────────────┬────────────┘
             ↓
┌─────────────────────────┐
│ Documentação do bug     │
└────────────┬────────────┘
             ↓
┌─────────────────────────┐
│ Correção                │
└────────────┬────────────┘
             ↓
┌─────────────────────────┐
│ Novo teste              │
└────────────┬────────────┘
             ↓
       All tests passed!
```

---

# 14. Conclusão

O laboratório demonstrou, na prática, como um teste de regressão pode identificar problemas causados por alterações realizadas no sistema.

Uma simples mudança no texto de um botão foi suficiente para fazer o teste automatizado falhar, pois o teste dependia da localização desse elemento pelo seu texto.

A atividade também demonstrou que um bug deve ser analisado e documentado de maneira organizada, apresentando:

* O problema encontrado;
* Os passos para reproduzi-lo;
* O resultado esperado;
* O resultado atual;
* A causa identificada;
* A solução aplicada.

Dessa forma, o processo de Qualidade de Software contribui para que alterações no sistema possam ser realizadas com maior controle e para que problemas sejam identificados antes de chegarem aos usuários finais.

**Ciclo realizado:**

**Criação do teste → Detecção da regressão → Análise → Documentação → Correção → Validação**
