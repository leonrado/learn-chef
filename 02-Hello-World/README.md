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
file '/tmp/motd' do
  content 'hello world'
end
```

Depois vamos chamar o chef-client para executar a nossa primeira receita em modo local:
```
chef-client --local-mode hello.rb
```
