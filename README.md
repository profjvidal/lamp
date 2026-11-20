
# Instalação de Servidor Web e Banco de Dados – LAMP

## Objetivo

Realizar a instalação e configuração inicial de um ambiente LAMP em um servidor Debian, utilizando um script de automação para disponibilizar serviços web e de banco de dados.

A atividade tem como objetivo proporcionar aos estudantes uma experiência prática de administração de servidores Linux, instalação de serviços e gerenciamento de banco de dados.

## Serviços instalados

- **Apache:** servidor responsável por hospedar e disponibilizar páginas e aplicações web.
- **PHP:** linguagem de programação utilizada no desenvolvimento de aplicações web.
- **MariaDB:** sistema gerenciador de banco de dados responsável pelo armazenamento e gerenciamento das informações.
- **phpMyAdmin:** ferramenta web que permite administrar bancos de dados MariaDB por meio de uma interface gráfica.

## Processo de instalação

### 1. Atualizar os repositórios do Debian

```bash
sudo apt update
```

### 2. Instalar o Git

```bash
sudo apt install git -y
```

### 3. Clonar o repositório

```bash
git clone https://github.com/profjvidal/lamp.git
```

### 4. Acessar o diretório

```bash
cd lamp
```

### 5. Permitir a execução do script

```bash
chmod +x lamp.sh
```

### 6. Executar o script de instalação

```bash
sudo ./lamp.sh
```

Aguarde a conclusão da instalação dos serviços.

## Acessando os serviços

Após a instalação, utilize o navegador para acessar:

- **Servidor Apache:** `http://IP-DO-SERVIDOR`
- **phpMyAdmin:** `http://IP-DO-SERVIDOR/phpmyadmin`

Substitua `IP-DO-SERVIDOR` pelo endereço IP configurado na máquina Debian.

## Verificação dos serviços

Verifique se os serviços estão em execução:

**Apache:**
```bash
sudo systemctl status apache2
```

**MariaDB:**
```bash
sudo systemctl status mariadb
```

**PHP:**
```bash
php -v
```

## Conteúdos trabalhados

- Instalação de serviços em servidores Linux.
- Administração de servidores web.
- Instalação e gerenciamento de servidores de banco de dados.
- Integração entre Apache, PHP e MariaDB.
- Utilização do phpMyAdmin para administração de bancos de dados.
- Automação de tarefas administrativas por meio de scripts Bash.
