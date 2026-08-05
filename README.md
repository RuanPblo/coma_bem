# Aplicativo Coma Bem

## Sobre o Projeto

O **Coma Bem** é um aplicativo mobile desenvolvido para conectar amantes da culinária a restaurantes locais, permitindo que usuários encontrem estabelecimentos, consultem informações e gerenciem seus dados de forma prática e segura.

Este projeto foi desenvolvido como parte da unidade curricular de **Banco de Dados Mobile**, com foco na aplicação de conceitos de banco de dados, Orientação a Objetos, persistência de dados e boas práticas de desenvolvimento utilizando Flutter.

---

## Tecnologias Utilizadas

- **Linguagem:** Dart
- **Framework:** Flutter
- **Banco de Dados:** SQLite (sqflite)
- **Padrões de Projeto:** Orientação a Objetos, DAO (Data Access Object)

---

## Modelagem do Banco de Dados

O banco de dados relacional foi construído respeitando as regras de normalização (1FN, 2FN e 3FN), reduzindo redundâncias e garantindo a integridade dos dados.

As principais tabelas do sistema são:

1. **Usuario**
2. **Cliente**
3. **Restaurante**
4. **Administrador**

---

## Arquitetura e Orientação a Objetos

O sistema foi desenvolvido utilizando os principais pilares da Orientação a Objetos.

### Encapsulamento

Todos os atributos das classes de modelo (como senha do usuário) são privados (`_`), sendo acessados apenas por meio de **getters** e **setters**. Os setters realizam validações antes de alterar os dados, garantindo maior segurança.

### Herança

Foram criadas classes especializadas, como:

- Cliente
- Administrador
- DonoRestaurante

Todas herdam características comuns da classe abstrata `Usuario`.

### Polimorfismo

Os métodos da classe `Usuario`, como `exibirMenu()`, são implementados de forma diferente em cada tipo de usuário, permitindo menus e funcionalidades específicas para cada perfil.

---

## Transações e Regras de Negócio (CRUD)

A classe `DatabaseHelper` é responsável pela conexão com o banco de dados SQLite no dispositivo móvel.

As operações utilizam tratamento de exceções (`try-catch`) e consultas parametrizadas para aumentar a segurança e evitar vulnerabilidades como SQL Injection.

- **Create:** Cadastro de usuários, restaurantes e demais registros.
- **Read:** Consulta de usuários, restaurantes e informações armazenadas.
- **Update:** Atualização dos dados cadastrados, como nome, e-mail e senha.
- **Delete:** Remoção de registros do banco de dados.

---

## Como Executar o Projeto

1. Clone este repositório.

```bash
git clone https://github.com/RuanPblo/coma_bem.git
```

2. Acesse a pasta do projeto.

```bash
cd coma_bem
```

3. Abra o projeto no Visual Studio Code.

4. Certifique-se de possuir o Flutter SDK instalado e um Emulador Android configurado.

5. Execute:

```bash
flutter pub get
```

6. Inicie o aplicativo:

```bash
flutter run
```

---

## Estrutura do Projeto

```
lib/
├── models/
├── database/
├── screens/
├── widgets/
└── main.dart
```

---

## Autor

Desenvolvido por **Ruan Pablo dos Santos Alves**

GitHub: https://github.com/RuanPblo