# Organizando nossas receitas

![palmirinha](palmirinha.jpg)

Forme nossas receitas vão crecendo de tamanho e ficando mais complexa, para falicitar o gerenciamento, vamos organizar-las em cookbooks

# 1. Criando Cookbook

## Missão: Criar um cookbook que instala um Servidor Web:

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

# 2 Criando Receita

Vamos criar uma receita fazer os seguintes passos:

1. Instalar o pacote o httpd
2. Startar o o serviço de httpd
3. Criar nosso index.html

Para isso vamos criar uma receita chamada install_web_server usando o "chef generate"
precisamos rodar esse comando de dentro do diretorio raiz do nosos Cookbook
```
cd cookbooks/learn_chef_httpd/
chef generate recipe install_web_server
```
Isso vai criar um arquivo chamado install_web_server.rb dentro do diretorio recipes
Vamos adicionar o seguinte codigo no seu conteudo:
```
package 'httpd'

service 'httpd' do
  action [:enable, :start]
end

file '/var/www/html/index.html' do
  content '<html>
  <body>
    <h1>hello world</h1>
  </body>
</html>'
end
```

Não ficou legal colocar o conteudo do nosso site todo usando esse recurso chamado
file. Vamos usar outro recurso chamado template e colocar o index em um arquivo separado:

# 3 Criado um template

Para separar o arquivo vamos criar um template usando novamente o comando "chef generate":

```
chef generate template index.html
```
Isso vai criar um diretorio chamado templates e um arquivo chamado index.html.erb
Vamos colocar o conteudo do nosso site nesse arquivo:
```
<html>
  <body>
    <h1>hello world</h1>
  </body>
</html>
```

E adicionar esse recurso em nossa receita, de forma que nosso arquivo install_web_server.rb
fique com esse conteudo:
```
package 'httpd'

service 'httpd' do
  action [:enable, :start]
end

template '/var/www/html/index.html' do
  source 'index.html.erb'
end
```

# 4 Rodando...

Vamos rodar a nossa receita localmente usando o comando:
```
sudo chef-client --local-mode --runlist 'learn_chef_httpd::install_web_server'
```
Isso vai gerar uma saida parecida com essa:
```
Starting Chef Client, version 13.4.19
resolving cookbooks for run list: ["install_web_server"]
Synchronizing Cookbooks:
  - learn_chef_httpd (0.1.0)
Installing Cookbook Gems:
Compiling Cookbooks...
Converging 3 resources
Recipe: learn_chef_httpd::default
  * yum_package[httpd] action install (up to date)
  * service[httpd] action enable (up to date)
  * service[httpd] action start (up to date)
  * template[/var/www/html/index.html] action create
    - update content in file /var/www/html/index.html from 2914aa to ef4ffd
    (no diff)
    - restore selinux security context

Running handlers:
Running handlers complete
Chef Client finished, 1/4 resources updated in 03 seconds
```

Pronto temos um Web Server instalado, vamos testar se tudo esta ok:
```
curl localhost
```
