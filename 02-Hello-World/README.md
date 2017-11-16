# Hello World !

__Instalação do Chef DK__

Para começar a brincar com o chef vamos precisar primeiro instalar o
ChefDK (development kit) e criar nossa primeira receita.

Para instalar o ChefDK no ~~Ruindows~~ Windows:
```
. { iwr -useb https://omnitruck.chef.io/install.ps1 } | iex; install -project chefdk -channel stable -version 0.16.28
```

Para instalar o ChefDK no Linux:
```
curl https://omnitruck.chef.io/install.sh | sudo bash -s -- -P chefdk -c stable -v 2.0.28
```

Vamos criar nossa primeira receita, para isso vamos criar um diretorio onde sera
armazenado as receitas:
```
mkdir ~/chef-repo
cd ~/chef-repo
```

Depois vamos criar um arquivo chamado hello.rb com o seguinte conteudo:
```
file '/tmp/hello' do
  content 'hello world'
end
```
Depois vamos chamar o chef-client para executar a nossa primeira receita em modo local:
```
chef-client --local-mode hello.rb
```

Isso vai gerar uma saida parecida com essa:
```
Starting Chef Client, version 13.1.31
[2017-11-16T14:14:35-02:00] INFO: *** Chef 13.1.31 ***
[2017-11-16T14:14:35-02:00] INFO: Platform: x86_64-linux-gnu
[2017-11-16T14:14:35-02:00] INFO: Chef-client pid: 3245
[2017-11-16T14:14:35-02:00] INFO: The plugin path /etc/chef/ohai/plugins does not exist. Skipping...
[2017-11-16T14:14:36-02:00] INFO: Run List is []
[2017-11-16T14:14:36-02:00] INFO: Run List expands to []
[2017-11-16T14:14:36-02:00] INFO: Starting Chef Run for lbarboza
[2017-11-16T14:14:36-02:00] INFO: Running start handlers
[2017-11-16T14:14:36-02:00] INFO: Start handlers complete.
resolving cookbooks for run list: []
[2017-11-16T14:14:37-02:00] INFO: Loading cookbooks []
Synchronizing Cookbooks:
Installing Cookbook Gems:
Compiling Cookbooks...
[2017-11-16T14:14:37-02:00] WARN: Node lbarboza has an empty run list.
Converging 1 resources
Recipe: @recipe_files::/home/leonardo/Documentos/Treinamentos/chef/learn-chef/chef/hello.rb
  * file[/tmp/hello] action create[2017-11-16T14:14:37-02:00] INFO: Processing file[/tmp/hello] action create (@recipe_files::/home/leonardo/Documentos/Treinamentos/chef/learn-chef/chef/hello.rb line 1)
[2017-11-16T14:14:37-02:00] INFO: file[/tmp/hello] created file /tmp/hello

    - create new file /tmp/hello[2017-11-16T14:14:37-02:00] INFO: file[/tmp/hello] updated file contents /tmp/hello

    - update content in file /tmp/hello from none to b94d27
    --- /tmp/hello	2017-11-16 14:14:37.173109328 -0200
    +++ /tmp/.chef-hello20171116-3245-grltwt	2017-11-16 14:14:37.173109328 -0200
    @@ -1 +1,2 @@
    +hello world
[2017-11-16T14:14:37-02:00] INFO: Chef Run complete in 0.388461368 seconds

Running handlers:
[2017-11-16T14:14:37-02:00] INFO: Running report handlers
Running handlers complete
[2017-11-16T14:14:37-02:00] INFO: Report handlers complete
Chef Client finished, 1/1 resources updated in 01 seconds
```

Vamos verificar que foi criado um arquivo em /tmp com o nome hello e com o conteudo
"hello world"
Agora temos documento dizendo que deve existir um arquivo /tmp/helo e seu conteudo
deve ser "hello world"

# Garantindo que o conteudo do arquivo hello não vai ser alterado por mais ninguem

Vamos imaginar que um amiguinho de trabalho alterou manualmente o arquivo hello
algo que pode ser feito simplemente com um:
```
echo 'hello Brazil' > /tmp/hello
```

Mas o correto e o que esta documentado é que o conteudo desse arquivo seja "hello world"
O chef vai corrigir isso para nós, vamos rodar novamente:
```
chef-client --local-mode hello.rb
```

vamos ter uma saida como essa:
```
[2017-11-16T14:18:21-02:00] INFO: Started chef-zero at chefzero://localhost:1 with repository at /home/leonardo/chef-team
  One version per cookbook

[2017-11-16T14:18:21-02:00] INFO: Forking chef instance to converge...
Starting Chef Client, version 13.1.31
[2017-11-16T14:18:21-02:00] INFO: *** Chef 13.1.31 ***
[2017-11-16T14:18:21-02:00] INFO: Platform: x86_64-linux-gnu
[2017-11-16T14:18:21-02:00] INFO: Chef-client pid: 3907
[2017-11-16T14:18:21-02:00] INFO: The plugin path /etc/chef/ohai/plugins does not exist. Skipping...
[2017-11-16T14:18:23-02:00] INFO: Run List is []
[2017-11-16T14:18:23-02:00] INFO: Run List expands to []
[2017-11-16T14:18:23-02:00] INFO: Starting Chef Run for lbarboza
[2017-11-16T14:18:23-02:00] INFO: Running start handlers
[2017-11-16T14:18:23-02:00] INFO: Start handlers complete.
resolving cookbooks for run list: []
[2017-11-16T14:18:23-02:00] INFO: Loading cookbooks []
Synchronizing Cookbooks:
Installing Cookbook Gems:
Compiling Cookbooks...
[2017-11-16T14:18:23-02:00] WARN: Node lbarboza has an empty run list.
Converging 1 resources
Recipe: @recipe_files::/home/leonardo/Documentos/Treinamentos/chef/learn-chef/chef/hello.rb
  * file[/tmp/hello] action create[2017-11-16T14:18:23-02:00] INFO: Processing file[/tmp/hello] action create (@recipe_files::/home/leonardo/Documentos/Treinamentos/chef/learn-chef/chef/hello.rb line 1)
[2017-11-16T14:18:23-02:00] INFO: file[/tmp/hello] backed up to /home/leonardo/.chef/local-mode-cache/backup/tmp/hello.chef-20171116141823.804105
[2017-11-16T14:18:23-02:00] INFO: file[/tmp/hello] updated file contents /tmp/hello

    - update content in file /tmp/hello from 0d1fb5 to b94d27
    --- /tmp/hello	2017-11-16 14:18:18.184680813 -0200
    +++ /tmp/.chef-hello20171116-3907-3gmhtt	2017-11-16 14:18:23.800761136 -0200
    @@ -1,2 +1,2 @@
    -hello Brazil
    +hello world
[2017-11-16T14:18:23-02:00] INFO: Chef Run complete in 0.371506073 seconds

Running handlers:
[2017-11-16T14:18:23-02:00] INFO: Running report handlers
Running handlers complete
[2017-11-16T14:18:23-02:00] INFO: Report handlers complete
Chef Client finished, 1/1 resources updated in 02 seconds
```

O chef identificou que o conteudo do arquivo não esta como deveria e corrigiu isso
para nós.
