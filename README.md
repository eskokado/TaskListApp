# Task List App
## Descrição
Os usuários podem se cadastrar, fazer login e gerenciar suas próprias listas de tarefas. Cada usuário tem um nome único, e-mail e senha para acesso seguro. Há a opção de assinatura premium, permitindo aos usuários cadastrar um cartão de crédito para upgrade.

No aplicativo, cada usuário pode criar, editar e excluir suas listas de tarefas, além de adicionar tarefas individuais com nomes, status (concluída ou não) e anexar documentos PDF ou imagens.
## Montar o ambiente de execução com docker-compose

  Faça o clone do aplicativo e entre no diretório.

## Iniciar o docker
### 1º Passo levantar o container
- Sem o log
```shell
docker-compose up -d
```
- Com log
```shell
docker-compose up
```
- Montar nova imagem e levantar o container
```shell
docker-compose up --build
```
### 2º Passo migração
- Criar o banco de dados
```shell
docker-compose exec app rails db:create
```
- Criar as tabelas
```shell
docker-compose exec app rails db:migrate
```
### Acessar o aplicativo 
#### Pelo nginx através da porta 8585
- [Entrar no applicativo localmente](http://localhost:8585)
#### Se falhar entrar pela porta 3000
- [Entrar no applicativo localmente pela porta 3000](http://localhost:3000)
### Registrar usuário e depois confirme pelo email através letter opener
- [Gerenciador de email localmente](http://localhost:3000/letter_opener)

### Opcional
#### Acessar banco de dados (POSTGRESQL)
- Porta: 5435
- Usuário: postgres
- Senha: postgres
- Banco de dados: task_list_app_development

##### Liberar o diretório gerado pelo docker
```shell
sudo chmod -R 755 postgres
```