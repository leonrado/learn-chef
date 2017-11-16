# Organizando nossas receitas

![palmirinha](palmirinha.jpg)

Forme nossas receitas vão crecendo de tamanho e ficando mais complexa, para falicitar o gerenciamento, vamos organizar-las em cookbooks

#1. Criando Cookbook

Vaos criar um cookbook que instala um Servidor Web:

Dentro do nosso diretorio chef-repo, vamos criar um diretorio para armanezar os
nossos cookbooks:
```
mkdir cookbooks
```

Agora vamos criar nosso cookbok. O chefDK tem um comando chamado "chef generate"
que nos ajuda a criar coisas. Vamos usa-lo para crair nosso cookbook:

```
chef generate cookbook cookbooks/learn_chef_httpd
```

Esperamos a seguinte saida:
```
Generating cookbook learn_chef_httpd
- Ensuring correct cookbook file content
- Ensuring delivery configuration
- Ensuring correct delivery build cookbook content

Your cookbook is ready. Type `cd cookbooks/learn_chef_httpd` to enter it.

There are several commands you can run to get started locally developing and testing your cookbook.
Type `delivery local --help` to see a full list.

Why not start by writing a test? Tests for the default recipe are stored at:

test/smoke/default/default_test.rb

If you'd prefer to dive right in, the default recipe can be found at:

recipes/default.rb
```

Esse commando vai gerar uma estrutura de diretórios assim:

```
.
├── Berksfile
├── chefignore
├── metadata.rb
├── README.md
├── recipes
│   └── default.rb
├── spec
│   ├── spec_helper.rb
│   └── unit
│       └── recipes
│           └── default_spec.rb
└── test
    └── smoke
        └── default
            └── default_test.rb

7 directories, 8 files
```
