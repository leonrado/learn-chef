# Usando Cookbooks da comunidade

Quando estiver escrevendo um cookbook, ou quando for pensar em escrever um, uma
boa ideia é verificar se ja não existe um cookbook pronto ou algum que lhe forneça
os resources para usar no seu cookbook.

O local para encontrar cookbooks é no [Supermarket](https://supermarket.chef.io/):

https://supermarket.chef.io/

Esse é o local usado pela comunidade para compartilhar seus codigos.

__Vamos ver na pratica como isso pode me ajudar:__

Em nosso cookbook, gostaria de adicionar a instalação de dois pacotes chamados htop e cmatrix.
Esse pacote não exitem no repositorio padrão da minha distribuição, então eu vou ter
que compila-lo apartir de um tarball.

Para eu não ter que escrever todo esse codigo, vou verifiar se encontro algo que
me ajude no supermarket.

Achei um cookbook chamado [tar](https://supermarket.chef.io/cookbooks/tar)

Olhei a documentação dele e parece ser simples de usar, A primeira coisa que preciso
fazer é baixa-lo para isso vou usar a ferramenta "knife" que vem no pacote do chefDK
Essa ferramentas faz muitas coisas, talvez tenhamos um capitulo so dela.

```
cd ~/chef-repo
knife cookbook site download tar
tar -xvzf tar-2.1.1.tar.gz
```

Agora temos o cookbook tar em nosso diretorio de cookbooks. Para que nosso cookbook
learn_chef_http use o cookbook tar, precisamod declarar ele como dependente.
Fazemos isso editando o arquivo metadata.rb.
ao abrir o arquivo, vamos encontrar algo assim:
```
name 'learn_chef_httpd'
maintainer 'The Authors'
maintainer_email 'you@example.com'
license 'All Rights Reserved'
description 'Installs/Configures learn_chef_httpd'
long_description 'Installs/Configures learn_chef_httpd'
version '0.1.0'
chef_version '>= 12.1' if respond_to?(:chef_version)

# The `issues_url` points to the location where issues for this cookbook are
# tracked.  A `View Issues` link will be displayed on this cookbook's page when
# uploaded to a Supermarket.
#
# issues_url 'https://github.com/<insert_org_here>/learn_chef_httpd/issues'

# The `source_url` points to the development repository for this cookbook.  A
# `View Source` link will be displayed on this cookbook's page when uploaded to
# a Supermarket.
#
# source_url 'https://github.com/<insert_org_here>/learn_chef_httpd'

depends 'tar'
```

Vamos aproveitar e inserir as informações de mainteiner e mainteiner_email atualizadas
e vamos adicionar uma linha dizendo que esse cookbook depende do cookbook 'tar'

vai ficar assim:
```
name 'learn_chef_httpd'
maintainer 'Leonardo Dias'
maintainer_email 'lbarboza@inmetrics.com.br'
license 'All Rights Reserved'
description 'Cookbook de exemplo'
long_description 'Esse cookbook é só um exemplo ultilizado em um curso sobre chef'
version '0.2.0'
chef_version '>= 12.1' if respond_to?(:chef_version)

# The `issues_url` points to the location where issues for this cookbook are
# tracked.  A `View Issues` link will be displayed on this cookbook's page when
# uploaded to a Supermarket.
#
# issues_url 'https://github.com/leonrado/learn_chef_httpd/issues'

# The `source_url` points to the development repository for this cookbook.  A
# `View Source` link will be displayed on this cookbook's page when uploaded to
# a Supermarket.
#
# source_url 'https://github.com/leonrado/learn_chef_httpd'

depends 'tar'
```

Pronto ! agora podemos usar o recurso tar_package em nosso cookbook

Vamos deixar nosso arquivo assim:
```
service 'httpd' do
  action [:enable, :start]
end

template '/var/www/html/index.html' do
  source 'index.html.erb'
end

tar_package 'https://hisham.hm/htop/releases/2.0.2/htop-2.0.2.tar.gz' do
  prefix '/usr/local'
  creates '/usr/local/bin/htop'
end
```

e vamos rodar novamente nossa receita:
```
sudo chef-client -z  --runlist 'learn_chef_httpd::install_web_server'
```

Mas o que aconteceu ??? deu um monte de erros aqui.

Calma que isso é o processo padrão de desenvolvimento. Rodar o seu codigo e
perceber que alguma coisa não esta certa, corrigir e rodar novamente é o processo
de todo o desenvolvedor.

Se algum erro acontecer na execução de algum recurso, o chef-client vai abortar a missão
e parar o processo mostrando a saida do erro

Ver ver a saida pra tentar descobrir qual foi o erro:

```
Starting Chef Client, version 13.2.20
resolving cookbooks for run list: ["learn_chef_httpd::install_web_server"]
Synchronizing Cookbooks:
  - learn_chef_httpd (0.1.0)
  - tar (2.1.1)
Installing Cookbook Gems:
Compiling Cookbooks...
Converging 4 resources
Recipe: learn_chef_httpd::install_web_server
  * service[httpd] action enable (up to date)
  * service[httpd] action start (up to date)
  * template[/var/www/html/index.html] action create (up to date)
  * tar_package[https://hisham.hm/htop/releases/2.0.2/htop-2.0.2.tar.gz] action install
    * remote_file[htop-2.0.2.tar.gz] action create_if_missing (up to date)
    * execute[extract htop-2.0.2.tar.gz] action run (up to date)
    * execute[compile & install htop-2.0.2] action run

      ================================================================================
      Error executing action `run` on resource 'execute[compile & install htop-2.0.2]'
      ================================================================================

      Mixlib::ShellOut::ShellCommandFailed
      ------------------------------------
      Expected process to exit with [0], but received '1'
      ---- Begin output of ./configure --quiet --prefix=/usr/local && make --quiet && make --quiet install ----
      STDOUT:
      STDERR: configure: error: in `/usr/local/src/htop-2.0.2':
      configure: error: no acceptable C compiler found in $PATH
      See `config.log' for more details
      ---- End output of ./configure --quiet --prefix=/usr/local && make --quiet && make --quiet install ----
      Ran ./configure --quiet --prefix=/usr/local && make --quiet && make --quiet install returned 1

      Resource Declaration:
      ---------------------
      # In /root/.chef/local-mode-cache/cache/cookbooks/tar/resources/package.rb

       61:   execute "compile & install #{dirname}" do
       62:     flags = [r.prefix ? "--prefix=#{r.prefix}" : nil, *r.configure_flags].compact.join(' ')
       63:     command "./configure --quiet #{flags} && make --quiet && make --quiet install"
       64:     cwd "#{src_dir}/#{dirname}"
       65:     creates r.creates
       66:   end
       67: end

      Compiled Resource:
      ------------------
      # Declared in /root/.chef/local-mode-cache/cache/cookbooks/tar/resources/package.rb:61:in `block in class_from_file'

      execute("compile & install htop-2.0.2") do
        action [:run]
        default_guard_interpreter :execute
        command "./configure --quiet --prefix=/usr/local && make --quiet && make --quiet install"
        backup 5
        creates "/usr/local/bin/htop"
        cwd "/usr/local/src/htop-2.0.2"
        returns 0
        user nil
        declared_type :execute
        cookbook_name "learn_chef_httpd"
        domain nil
      end

      System Info:
      ------------
      chef_version=13.2.20
      platform=centos
      platform_version=6.9
      ruby=ruby 2.4.1p111 (2017-03-22 revision 58053) [x86_64-linux]
      program_name=chef-client worker: ppid=13753;start=21:47:20;
      executable=/opt/chefdk/bin/chef-client


    ================================================================================
    Error executing action `install` on resource 'tar_package[https://hisham.hm/htop/releases/2.0.2/htop-2.0.2.tar.gz]'
    ================================================================================

    Mixlib::ShellOut::ShellCommandFailed
    ------------------------------------
    execute[compile & install htop-2.0.2] (/root/.chef/local-mode-cache/cache/cookbooks/tar/resources/package.rb line 61) had an error: Mixlib::ShellOut::ShellCommandFailed: Expected process to exit with [0], but received '1'
    ---- Begin output of ./configure --quiet --prefix=/usr/local && make --quiet && make --quiet install ----
    STDOUT:
    STDERR: configure: error: in `/usr/local/src/htop-2.0.2':
    configure: error: no acceptable C compiler found in $PATH
    See `config.log' for more details
    ---- End output of ./configure --quiet --prefix=/usr/local && make --quiet && make --quiet install ----
    Ran ./configure --quiet --prefix=/usr/local && make --quiet && make --quiet install returned 1

    Resource Declaration:
    ---------------------
    # In /root/.chef/local-mode-cache/cache/cookbooks/learn_chef_httpd/recipes/install_web_server.rb

     19: tar_package 'https://hisham.hm/htop/releases/2.0.2/htop-2.0.2.tar.gz' do
     20:   prefix '/usr/local'
     21:   creates '/usr/local/bin/htop'
     22: end
     23:

    Compiled Resource:
    ------------------
    # Declared in /root/.chef/local-mode-cache/cache/cookbooks/learn_chef_httpd/recipes/install_web_server.rb:19:in `from_file'

    tar_package("https://hisham.hm/htop/releases/2.0.2/htop-2.0.2.tar.gz") do
      action [:install]
      default_guard_interpreter :default
      declared_type :tar_package
      cookbook_name "learn_chef_httpd"
      recipe_name "install_web_server"
      prefix "/usr/local"
      creates "/usr/local/bin/htop"
      source "https://hisham.hm/htop/releases/2.0.2/htop-2.0.2.tar.gz"
    end

    System Info:
    ------------
    chef_version=13.2.20
    platform=centos
    platform_version=6.9
    ruby=ruby 2.4.1p111 (2017-03-22 revision 58053) [x86_64-linux]
    program_name=chef-client worker: ppid=13753;start=21:47:20;
    executable=/opt/chefdk/bin/chef-client


Running handlers:

```

Vemos aqui que o erro aconteceu rodar o resource tar_package...
outra pista foi essa linha:
```
STDERR: configure: error: in `/usr/local/src/htop-2.0.2':
configure: error: no acceptable C compiler found in $PATH
See `config.log' for more details
```

Que cabeça a minha, esqueci pra compilar alguma coisa, eu preciso do pacote gcc..
ja vou aproveitar e adicionar o pacote ncurses-devel porque eu sei que vou preciar
também.

meu arquivo install_web_server.rb ficou assim:

```
package 'httpd'
package 'gcc'
package 'ncurses-devel'

service 'httpd' do
  action [:enable, :start]
end

template '/var/www/html/index.html' do
  source 'index.html.erb'
end

tar_package 'https://hisham.hm/htop/releases/2.0.2/htop-2.0.2.tar.gz' do
  prefix '/usr/local'
  creates '/usr/local/bin/htop'
end
```
