# Hello World !

__Instalação do Chef DK__

Para começar a brincar com o chef vamos precisar primeiro instalar o
ChefDK (development kit) e criar nossa primeira receita.

Para instalar o ChefDK no Windows:
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
chef-client --local-mode hello.rb
[2017-08-09T11:20:32+00:00] WARN: No config file found or specified on command line, using command line options.
[2017-08-09T11:20:32+00:00] WARN: No cookbooks directory found at or above current directory.  Assuming /root/chef-repo.
Starting Chef Client, version 13.2.20
resolving cookbooks for run list: []
Synchronizing Cookbooks:
Installing Cookbook Gems:
Compiling Cookbooks...
[2017-08-09T11:20:36+00:00] WARN: Node ip-172-31-11-105.ec2.internal has an empty run list.
Converging 1 resources
Recipe: @recipe_files::/root/chef-repo/hello.rb
  * file[/tmp/motd] action create
    - create new file /tmp/motd
    - update content in file /tmp/motd from none to b94d27
    --- /tmp/motd   2017-08-09 11:20:36.690541944 +0000
    +++ /tmp/.chef-motd20170809-11826-6f9rrp    2017-08-09 11:20:36.690541944 +0000
    @@ -1 +1,2 @@
    +hello world
    - restore selinux security context

Running handlers:
Running handlers complete
Chef Client finished, 1/1 resources updated in 03 seconds
[2017-08-09T11:20:36+00:00] WARN: No config file found or specified on command line, using command line options.
```

Vamos verificar que foi criado um arquivo em /tmp com o nome hello e com o conteudo
"hello world"
Agora temos documento dizendo que deve existir um arquivo /tmp/helo e seu conteudo
deve ser "hello world"

# Garantindo que o conteudo do arquivo hello não vai ser alterado por mais ninguem

Vamos imaginar que um amiguinho de trabalho alterou manualmente o arquivo hello
algo que pode ser feito simplemente com um:
```
echo 'hello Brazil' > /tmp/motd
```

Mas o correto e o que esta documentado é que o conteudo desse arquivo seja "hello world"
O chef vai corrigir isso para nós, vamos rodar novamente:
```
chef-client --local-mode hello.rb
```
