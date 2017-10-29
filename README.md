# Questpool

Essa aplicação tem a finalidade de ser um repositório de questões, onde será
possível criar questões que poderão ser avaliadas por um administrador, que
por sua vez poderá fazer sugestões de como melhorar as questões adicionadas pelos
demais usuários.   

### Modelo

![Classes](https://user-images.githubusercontent.com/1520647/32139439-0f1f0512-bc1f-11e7-9480-5b4345c691a8.png)

![Modelo Banco de Dados](https://user-images.githubusercontent.com/1520647/32139539-19d77fae-bc22-11e7-9e32-908b0ddb67f7.png)

Um usuário (User) pode criar questões quando tiver a permissão (atributo role) de 'user' ou poderá avaliar as questões quando a sua permissão for 'admin'.
Quando um usuário cria uma questões estará associado diretamente a questão, quando o usuário reprova uma questão, ele está  o usuário estará associado por meio da dica deixada (Hint).
Cada questão tem cinco alternativas associadas sendo que uma deve ser marcada como correta (atributo correct).

### Especificações Técnicas

* Versão Ruby: 2.3.4
* Versão Rails: 5.1.4
* Banco de Dados: Mysql
* Schema de Autenticação: [Device](https://github.com/plataformatec/devise)
* Sistema de Dependencias: [Bundler](http://bundler.io)
* Configuration
* Database creation
* Database initialization
* How to run the test suite
* Services (job queues, cache servers, search engines, etc.)
* Deployment instructions


### Instalação

1. Inicialmente, instale as depêndencias com o comando:

```
bundle install
```

2. Altere o arquivo _config/database.yml_ adicionando as credenciais do banco mysql local.

3. Crie as bases de dados com o seguinte comando:

```
rails db:create
```

4. Crie as tabelas da aplicação por meio rodando as migrations da aplicação com o comando:

```
rails db:migrate
```

5. O arquivo _db/seeds.rb_ possui um codigo ruby que cria um usuário administrador do sistema. O comando a baixo roda o código nesse arquivo e exibe as credenciais para acesso do sistema para o usuário administrado criado.

```
rails db:seed  
```  

6. Inicialize o servidor

```
rails s
```

7. Acesse no browser o endereço
```
localhost:3000/
```

Se tudo ocorreu bem, você deve ver a seguinte tela:

![Tela Incial](https://user-images.githubusercontent.com/1520647/32140056-1f2f5eda-bc32-11e7-9e73-b5539b332e4a.png)



Em seguida, rode os commandos para criação da base dados

### TODOS

* Tradução de campos e Modelos, hora funciona, hora não funciona.
* Metodos approve e disapprove estão como get, por conta de um problema com a autenticação do devise devem ser post.
