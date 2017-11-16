# Usando Resources

Um componente importante na hora de escrever recitas são os resources.
Para criar nosso cookbook usamos 3 deles:

- package
- service
- template

Abaixo segue um link para a documentação do chef que contém a lista de todos os recuros padroes
https://docs.chef.io/resource.html#resources

*Um recurso é uma função que nos ajuda a expressar o estado desejado de configuração
de um pedaço do sistema.*

Parece complicado, mas é mais facil que isso.

Um resource tem uma função especifica e vai nos ajudar a implementar uma configuração.

A syntax de um recuroso geralmente é:
```
resource 'name' do
   attribute 'value'
   action :type_of_action
end
```

Os attributes e Acition dos resources tem valores padroes, por isso quando instalamos
fizemos simplemente:

package "httpd"

Pois o ação padrão do resource package é o install. caso precisemos alterar algum attribute
ou action de um resource, basta declarar o novo valor:
```
package 'tar' do
  version '1.16.1'
  action :install
end
```

Para sabermos toda a lista de attributes e actions de um resource, temos que
consultar a sua documentação.

# Custom Resources

Custom resources são resources que estão no "CORE" do chef-client e geralmente são
disponibilizados de um outro cookbook.
Isso quer dizer que podemos criar nossos proprios recursos ou usar recursos que a
comunidade nos disponibiliza.
