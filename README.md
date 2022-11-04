# DevOps-Prat
Estudando e praticando metodologias DevOps (Docker, Kubernetes, Rancher, etc.)

#1: Configuração de Vm's

Para essa atividade, estaremos levantando 4 Maquinas virtuais com as mesmas configurações, sendo elas:
- 2 processadores e 2 gb de memória ram
- Sistema operacional Centos/7 e com a instalação do Docker. 

As maquinas são:
- Rancher_Server: Será o servidor do Rancher
- k8s_1: Irá compor o Cluster Kubernets
- k8s_2: Irá compor o Cluster Kubernets
- k8s_3: Irá compor o Cluster Kubernets

Para está atividade, também vamos precisar de um domínio, que usarei o disponibilizado pelo professos na auta em que estou tomando por referência para esta atividade.

#2: Preparando a VM1 (Rancher_Server)

Nessa etapa, logamos a través do comando $vagrant ssh na nossa máquina virtual, instaleremos as seguintes dependências e executamos os comandos: 
$ sudo su
$ apt-get install git -y
$ curl -L "https://github.com/docker/compose/releases/download/1.25.5/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
$ chmod +x /usr/local/bin/docker-compose
$ ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose

Com os pacotes instalados, agora iremos baixar o código fonte e começaremos a fazer os build's e rodar os containers.
$ cd /home/
$ git clone https://github.com/jonathanbaraldi/devops
$ cd devops/exercicios/app

Fazemos o build da imagem do Redis para nossa aplicação com os seguintes comandos:
$ cd redis
$ docker build -t <dockerhub-user>/redis:devops .
$ docker run -d --name redis -p 6379:6379 <dockerhub-user>/redis:devops
$ docker ps
$ docker logs redis

Fazemos o build do container do NodeJs
$ cd ../node
$ docker build -t <dockerhub-user>/node:devops .

Agora iremos rodar a imagem do node, fazendo a ligação dela com o container do Redis:
$ docker run -d --name node -p 8080:8080 --link redis <dockerhub-user>/node:devops
$ docker ps 
$ docker logs node

Com isso temos nossa aplicação rodando, e conectada no Redis. A api para verificação pode ser acessada em /redis. Após o final de cada build sempre verificamos nosso localhost pra saber se tudo está funcionando certo.

Iremos fazer o build do container do nginx, que será nosso balanceador de carga:
$ cd ../nginx
$ docker build -t <dockerhub-user>/nginx:devops .

Criamos o container do nginx e fazemos a ligaçãp com o container do Node
$ docker run -d --name nginx -p 80:80 --link node <dockerhub-user>/nginx:devops
$ docker ps

Podemos acessar então nossa aplicação nas portas 80 e 8080 no ip da nossa instância.

Iremos acessar a api em /redis para nos certificar que está tudo ok, e depois iremos limpar todos os containers e volumes para agora realizarmos o build de nossos container de uma vez só através do Docker-compose...