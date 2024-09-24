# GithubRepoFetcher

Esta API foi criada como parte de um desafio feito pelo youtuber Bolt [link do video](https://www.youtube.com/watch?v=GjA4Qmbiiwc) e tem como objetivo fornecer dados dos repositórios de usuários do GitHub. Ela utiliza a API pública do GitHub para buscar informações sobre repositórios de um usuário.

## Tecnologias Utilizadas

- Ruby on Rails
- GitHub API

# Dependências

Ruby v3.3.4

## Como instalar o projeto

depois de clonar o projeto use os comandos abaixo

```Bash
gem install rails
bin/setup
```

## Como Rodar o projeto

para rodar o projeto na porta 3000

```Bash
bin/rails server
```

# Uso

## obtém todos os repositórios do usuário

```Bash
GET v1/repos/:username  # sem paginação
GET v1/repos/:username?page=2  # com paginação
```

### exemplo de requisição

```Bash
curl http://localhost:3000/v1/repos/fabio-k
```

### exemplo de resposta:

```Bash
{
  "user": "fabio-k",
  "current_page": 1,
  "last_page": "",
  "repositories": [
    {
      "name": "GitHubRepoFetcher",
      "forks_count": 0,
      "stars_count": 0,
      "description": "",
      "url": "https://github.com/Fabio-k/GitHubRepoFetcher"
    }
  ]
}
```

## obtém um repositório específico do usuário

```Bash
GET v1/repo/:username/:repository_name #sem paginação
GET v1/repo/:username/:repository_name?page=2 #com paginação
```

### exemplo de requisição:

```Bash
curl http://localhost:3000/v1/repo/fabio-k/LearnTools
```

### exemplo de resposta:

```Bash
{
  "repository": {
    "name": "LearnTools",
    "forks_count": 0,
    "stars_count": 1,
    "description": "site que ajuda a melhorar a qualidade dos estudos oferecendo ferramentas de estudo  aprimoradas com LLM",
    "url": "https://github.com/Fabio-k/LearnTools",
    "commits": [
      {
        "message": "Merge pull request #17 from Fabio-k/dev\n\nFaz correção importante nas tabela do banco de dados",
        "author": "Fábio Kazuhiro Mizo Guti"
      },
      {
        "message": "refactor atualiza as tabelas do banco para tornar possivel a deletar tabelas e atualiza os prompts",
        "author": "fabio-k"
      }
    ]
  },
  "current_page": 1,
  "last_page": 3
}
```
