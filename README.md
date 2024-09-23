# GithubRepoFetcher

Esta API foi criada como parte de um desafio feito pelo youtuber Bolt [link do video](https://www.youtube.com/watch?v=GjA4Qmbiiwc) e tem como objetivo fornecer dados dos repositórios de usuários do GitHub. Ela utiliza a API pública do GitHub para buscar informações sobre repositórios de um usuário.

## Tecnologias Utilizadas

- Ruby on Rails
- GitHub API

# Dependecias

Ruby v3.3.4

## Como instalar o projeto

depois de clonar o projeto use o comamdo abaixo

```Bash
    bin/setup
```

## Como Rodar o projeto

para rodar o projeto na porta 3000

```Bash
    bin/rails server
```

# Uso

obtem todos os repositórios do usuário

```Bash
    GET /repos/:username  # sem paginação
    GET /repos/:username?page=2  # com paginação
```

ogtem dados específicos de um repositório do usuário

```Bash
    GET /repo/:username/:repository_name #sem paginação
    GET /repo/:username/:repository_name?page=2 #com paginação
```
